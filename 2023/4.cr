sum = 0

# First part

# File.each_line("./4.realin") do |line|
#   sp = line.split(":")[1].split("|")
#   winning = sp[0]
#   mine = sp[1]

#   nums = mine.split(" ")

# #   puts "winning points: #{winning}, my points: #{mine}"
#   matches = 0
#   size = nums.size
#   i = 0
#   until i >= size
#     if nums[i] != "" && winning.includes? " #{nums[i]} "
#         # puts "Found number: #{nums[i]}"
#         matches += 1
#     end
#     i += 1
#   end

#   if matches != 0
#     sum += 2**(matches-1)
#   end
# end

def process_line(winning : String, nums : Array) : Int32
  matches = 0
  size = nums.size
  i = 0
  until i >= size
    if nums[i] != "" && winning.includes? " #{nums[i]} "
      # puts "Found number: #{nums[i]}"
      matches += 1
    end
    i += 1
  end
  return matches
end

cards = Array(Int32).new(206, 1)
cards[0] = 0

File.each_line("./4.realin") do |line|
  both = line.split(":")
  nCard = both[0].split(" ")
  nCard = nCard[nCard.size - 1].to_i
  puts "Processing real card #{nCard}"
  sp = both[1].split("|")
  winning = sp[0]
  mine = sp[1]

  nums = mine.split(" ")

  n = cards[nCard]

  initialMatches = process_line(winning, nums)
  until n <= 0
    matches = initialMatches
    while matches > 0
      cards[nCard + matches] += 1
      matches -= 1
    end
    n -= 1
  end
end

i = cards.size - 1
until i <= 0
  sum += cards[i]
  i -= 1
end

puts "total points: #{sum} "
