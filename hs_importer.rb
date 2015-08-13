require_relative 'rating_data'

class ArenaDrafter
  attr_reader :card_ratings

	def initialize(card_ratings)
    @card_ratings = card_ratings
	end

  # too much responsibility, refactor some into Pack
  def draft_deck(hero_class, pack)
    deck = []
    pack.each do |pick|
    deck << card_ratings[hero_class][pick].values.sample(3).max
    end
    deck
  end

end


class Pack
  attr_reader :picks

  DEFAULT_PICKS = [:rare] * 4 + [:common] * 26
  UPGRADE_ODDS = 5

  def initialize(picks = DEFAULT_PICKS)
    @picks = picks
  end

  # assumes equal chance to upgrade across tiers, cascading
  def seed_rarities
    picks.map do |pick|
      rolling_rarity = pick
      while rand(UPGRADE_ODDS) == 0 && rolling_rarity != :legendary
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

module Enumerable

    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end

end 

# pb = Pack.new
# pack = []
# 1000.times { 
#   pack += pb.seed_rarities }
#   puts "common: #{pack.count(:common)}"
#   puts "rare: #{pack.count(:rare)}"
#   puts "epic: #{pack.count(:epic)}"
#   puts "legendary: #{pack.count(:legendary)}"
#   puts "....."


puts "__hero__   score | stdev "
CARD_RATINGS_BY_HERO.keys.each do |hero_class|
  means = []
  stdevs = []
  10000.times do
    pack = Pack.new.seed_rarities
    draft = ArenaDrafter.new(CARD_RATINGS_BY_HERO)
    deck = draft.draft_deck(hero_class, pack)
    means << deck.mean
    stdevs << deck.standard_deviation
  end
  puts "#{hero_class}: #{" " * (8 - hero_class.length)} #{means.mean.round(2)} | #{stdevs.mean.round(2)} "
end