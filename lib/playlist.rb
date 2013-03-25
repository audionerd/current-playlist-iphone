require 'open-uri'
require 'nokogiri'
require 'tzinfo'

class Playlist
  def self.recent
    # begin
      time = TZInfo::Timezone.get("America/Chicago").now

      uri   = "http://www.thecurrent.org/playlist/#{time.strftime("%Y-%m-%d/%-k")}?isajax=1"

      doc = Nokogiri::HTML.fragment(open(uri).read)

      doc.css("article").map do |a|
        title       = (a/"h5.title").text
        creator     = (a/"h5.artist").text
        begin
          song_id     = a.attr('id').gsub(/^song/, '')
          detail_uri  = "http://www.thecurrent.org/playlist/catalog/%s" % song_id
          album       = Nokogiri::HTML.fragment(open(detail_uri).read).css('section.content span').first.text
        rescue
          song_id     = ""
          detail_uri  = "#"
          album       = "---"
        end
        {
          :title => title,
          :creator => creator,
          :song_id => song_id,
          :detail_uri => detail_uri,
          :album => album
        }
      end
    # rescue
    #   {}
    # end
  end
end