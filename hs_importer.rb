class ArenaCalculator

	def initialize(card_ratings)
    @card_ratings = card_ratings
	end

end

class PackBuilder

  attr_reader :picks

  DEFAULT_PICKS = [:rare] * 4 + [:common] * 26

  def initialize(picks = DEFAULT_PICKS)
    @picks = picks
  end

  def seed_rarities
    picks.map do |pick|
      rolling_rarity = pick
      while rand(5) == 0 && rolling_rarity != :legendary
        if rolling_rarity == :common
          rolling_rarity = :rare
        elsif rolling_rarity == :rare
          rolling_rarity = :epic
        elsif rolling_rarity == :epic
          rolling_rarity = :legendary
          break
        end
      end
      rolling_rarity
    end
  end

end

pb = PackBuilder.new
pack = []
1000.times { 
  pack += pb.seed_rarities }
  puts "common: #{pack.count(:common)}"
  puts "rare: #{pack.count(:rare)}"
  puts "epic: #{pack.count(:epic)}"
  puts "legendary: #{pack.count(:legendary)}"
  puts "....."