require "open-uri"
require "json"

# Links:
# https://www.ietf.org/rfc/
# https://datatracker.ietf.org/doc/search?name=gcp&sort=&rfcs=on&activedrafts=on&by=group&group=

Bundler.require(:default, :development)

class RFC
  attr_accessor

  def self.get_source(num, type)
    source = if File.exist?("rfcs/rfc#{num}.#{type}")
      File.read("rfcs/rfc#{num}.#{type}")
    else
      url = "https://www.ietf.org/rfc/rfc#{num}.#{type}"
      puts "Fetching #{url}"
      URI.open(url).read.tap do |source|
        File.write("rfcs/rfc#{num}.#{type}", source)
      end
    end
  end
end

URL_PATTERN = "https://datatracker.ietf.org/doc/rfc%d/"

fields = ["draft", "doc_id", "title", "authors", "pub_status", "status", "source", "abstract", "pub_date", "keywords", "obsoletes", "obsoleted_by", "updates", "updated_by", "see_also", "doi", "errata_url"]
csv_ary = [fields]
(8912..9000).each do |num|
  source = RFC.get_source(num, "json")
  # json = JSON.parse(source)
  # pp json
  # csv_ary << json.values_at(*fields)
  # doc = Nokogiri::HTML(source)
  # title, date = (doc / "meta[name='description']")
  #   .first
  #   .attr('content')
  #   .match(/(.*) \(RFC \d+, (.*)\)/)
  #   .to_a[1..-1]
  # fields = (doc / "table.table-condensed tbody")
  #   .map { |tbody|
  #     [
  #       (tbody / "tr:first-child th:first-child").text,
  #       (tbody / "tr")
  #         .map { |tr|
  #           [
  #             (tr / "th:nth-child(2)").first.text.strip,
  #             (tr / "td:nth-child(4)").first.text.strip.lines.map(&:strip).reject { |l| l.size == 0 }
  #           ]
  #         }.to_h
  #     ]
  #   }.to_h
  # puts title
  # puts date
  # pp fields
end
puts csv_ary.map{ |l| l.join(",") }.join("\n")
