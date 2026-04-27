require "omniauth-oauth2"
require "net/http"
require "json"
require "securerandom"

module OmniAuth
  module Strategies
    class Line < OmniAuth::Strategies::OAuth2
      option :name, "line"
      option :scope, "profile openid email"

      option :client_options, {
        site: "https://api.line.me",
        authorize_url: "https://access.line.me/oauth2/v2.1/authorize",
        token_url: "https://api.line.me/oauth2/v2.1/token"
      }

      uid { raw_info["userId"] }

      info do
        {
          name: id_token_info["name"] || raw_info["displayName"],
          email: id_token_info["email"],
          image: raw_info["pictureUrl"]
        }
      end

      extra do
        { raw_info: raw_info, id_token_info: id_token_info }
      end

      # nonceを発行して認可URLに付与(リプレイ攻撃対策)
      def authorize_params
        super.tap do |params|
          nonce = SecureRandom.hex(16)
          session["omniauth.line.nonce"] = nonce
          params[:nonce] = nonce
        end
      end

      # Renderなどリバースプロキシ下ではfull_hostが正しく取れないため、
      # 本番では環境変数で完全一致のcallback_urlを指定する
      def callback_url
        options[:callback_url].presence ||
          ENV["LINE_CALLBACK_URL"].presence ||
          (full_host + script_name + callback_path)
      end

      def raw_info
        @raw_info ||= access_token.get("/v2/profile").parsed || {}
      rescue ::OAuth2::Error, ::Timeout::Error, ::SystemCallError, ::SocketError => e
        log :error, "raw_info fetch failed: #{e.class}: #{e.message}"
        {}
      end

      def id_token_info
        @id_token_info ||= verify_id_token
      end

      private

      # LINEのverify APIにid_tokenを投げて検証付きでpayloadを取得
      def verify_id_token
        id_token = access_token.params["id_token"]
        return {} if id_token.blank?

        res = Net::HTTP.post_form(
          URI("https://api.line.me/oauth2/v2.1/verify"),
          id_token: id_token,
          client_id: options.client_id
        )
        unless res.is_a?(Net::HTTPSuccess)
          log :error, "verify API non-success status: #{res.code}"
          return {}
        end

        payload = JSON.parse(res.body)
        expected_nonce = session.delete("omniauth.line.nonce")
        # sessionにnonceが無いケースも含めて拒否(リプレイ攻撃対策)
        if expected_nonce.blank? || payload["nonce"] != expected_nonce
          log :error, "nonce verification failed"
          return {}
        end

        payload
      rescue JSON::ParserError => e
        log :error, "verify API JSON parse error: #{e.message}"
        {}
      rescue ::Timeout::Error, ::SystemCallError, ::SocketError => e
        log :error, "verify API network error: #{e.class}: #{e.message}"
        {}
      end
    end
  end
end
