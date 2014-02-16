module ApplicationHelper
  def gravatar_url(player, options = {})
    options.assert_valid_keys :size
    size = options[:size] || 32
    digest = player.email.blank? ? "0" * 32 : Digest::MD5.hexdigest(player.email)
    "http://www.gravatar.com/avatar/#{digest}?d=mm&s=#{size}"
  end

  def time_ago_in_words_short(time)
    time_ago_in_words(time)
      .gsub(/less than a minute/, "now")
      .gsub(/ minute(s?)/, "m")
      .gsub(/ hour(s?)/, "h")
      .gsub(/ day(s?)/, "d")
      .gsub(/ year(s?)/, "y")
      .gsub(/about/, "")
  end
end
