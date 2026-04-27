require "line/bot/v2/messaging_api/api/messaging_api_client"
require "line/bot/v2/messaging_api/model/push_message_request"
require "line/bot/v2/messaging_api/model/text_message"

class LineNotifier
  include Rails.application.routes.url_helpers

  WEEKDAY_NAMES = %w[月 火 水 木 金 土 日].freeze

  def initialize(user)
    @user = user
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def schedule_registered(schedule)
    return unless @user.line_provider?

    push_text(build_schedule_registered_text(schedule))
  end

  private

  def push_text(text)
    request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: @user.uid,
      messages: [ Line::Bot::V2::MessagingApi::TextMessage.new(text: text) ]
    )
    _body, status_code, _headers = client.push_message_with_http_info(push_message_request: request)

    unless (200..299).cover?(status_code)
      Rails.logger.error("[LineNotifier] push failed: status=#{status_code} uid=#{@user.uid}")
    end
  rescue StandardError => e
    Rails.logger.error("[LineNotifier] push exception: #{e.class}: #{e.message}")
  end

  def client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV.fetch("LINE_MESSAGING_CHANNEL_ACCESS_TOKEN")
    )
  end

  def build_schedule_registered_text(schedule)
    lines = [ "📚 学習予定を登録しました!", "" ]
    lines << "■ 学習期間"
    lines << "#{format_date(schedule.start_date)}〜#{format_date(schedule.end_date)}"
    lines << ""
    lines << "■ 1日の目標学習時間"
    lines << "#{schedule.daily_study_hours}時間"

    if schedule.weekdays.present?
      lines << ""
      lines << "■ 学習曜日"
      lines << schedule.weekdays.compact.map { |i| WEEKDAY_NAMES[i] }.join("、")
    end

    if schedule.study_units.any?
      lines << ""
      lines << "■ 学習ユニット"
      lines << schedule.study_units.map(&:name).join("、")
    end

    if schedule.memo.present?
      lines << ""
      lines << "■ メモ・目標"
      lines << schedule.memo
    end

    lines << ""
    lines << "詳細はこちら:"
    lines << profile_url
    lines.join("\n")
  end

  def format_date(date)
    return "" if date.blank?
    "#{date.month}月#{date.day}日"
  end
end
