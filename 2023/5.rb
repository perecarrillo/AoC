def convertPart1(seeds, nextMap)
  output = Array.new
    for seed in seeds
      finalSeed = seed
      for line in nextMap
        range = line.at(2)
        
        destStart = line.at(0)
        destEnd = destStart + range
        
        sourceStart = line.at(1)
        sourceEnd = sourceStart + range
        
        # puts("Seed: #{seed}, destStart: #{destStart}, destEnd: #{destEnd}, sourceStart: #{sourceStart}, sourceEnd: #{sourceEnd}")
        
        difference = destStart - sourceStart
        
        if sourceStart <= seed and sourceEnd >= seed
          finalSeed = seed + difference
          # puts("Changed seed from #{seed} to #{finalSeed}")
        end
      end
      output.push(finalSeed)
    end
    return output
end

def convertPart2(seeds, nextMap)
  output = Array.new
  i = 0
  until i >= seeds.length()
    seedStart = seeds[i]
    seedRange = seeds[i+1]
    seedEnd = seedStart + seedRange - 1 # Including both ends
    i += 2
    finalSeeds = []
      for line in nextMap
        range = line.at(2)
        
        destStart = line.at(0)
        destEnd = destStart + range - 1
        
        sourceStart = line.at(1)
        sourceEnd = sourceStart + range - 1
        
        # puts("seedStart: #{seedStart}, seedEnd: #{seedEnd}, destStart: #{destStart}, destEnd: #{destEnd}, sourceStart: #{sourceStart}, sourceEnd: #{sourceEnd}")
        
        difference = destStart - sourceStart
        
        if sourceStart >= seedStart and sourceStart <= seedEnd and sourceEnd >= seedStart and sourceEnd <= seedEnd
          # Case 2
          # puts("Case 2")
          seeds.push([seedStart, (sourceStart - 1) - (seedStart) + 1]).flatten! # Add start back to the seeds
          seeds.push([sourceEnd + 1, (seedEnd) - (sourceEnd + 1) + 1]).flatten! # Add end back to the seeds
          finalSeeds.push([sourceStart + difference, (sourceEnd) - (sourceStart) + 1]) # The middle part can be mapped
          break
        end
        if sourceStart <= seedStart and sourceEnd >= seedEnd
          # Case 4
          # puts("Case 4")
          finalSeeds.push([seedStart + difference, (seedEnd) - (seedStart) + 1])
          break
        end
        if sourceStart <= seedStart and sourceEnd >= seedStart and sourceEnd <= seedEnd
          # Case 1
          # puts("Case 1")
          seeds.push([sourceEnd + 1, (seedEnd) - (sourceEnd + 1) + 1]).flatten!
          finalSeeds.push([seedStart + difference, (sourceEnd) - (seedStart) + 1])
          break
        end
        if sourceStart >= seedStart and sourceStart <= seedEnd and sourceEnd >= seedEnd
          # Case 3
          # puts("Case 3")
          seeds.push([seedStart, (sourceStart - 1) - (seedStart) + 1]).flatten! # Add start back to the seeds
          finalSeeds.push([sourceStart + difference, (seedEnd) - (sourceStart) + 1])
          break
        end
          
      end
      if finalSeeds.length == 0
        # puts("No colision")
        finalSeeds = [seedStart, seedRange]
      end
      output.push(finalSeeds).flatten!
      # puts("seeds: #{seeds}")
      # puts("final Seeds: #{finalSeeds.inspect()}")
  end
  # puts("Output: #{output.inspect()}")
  return output
end

seeds = gets.scan(/\d+/).map(&:to_i)
foo = gets
while true
  # Read Input
  foo = gets
  puts(foo)
  line = gets
  if line.to_s.strip.empty?
    break
  end
  newMap = Array.new()
  while not line.to_s.strip.empty?
    a = line.scan(/\d+/).map(&:to_i)
    # puts(a)
    newMap.push(a)
    line = gets
  end
  seeds = convertPart2(seeds, newMap)
  # puts(newMap.inspect)
  # minSeed = seeds.min()
  # puts(minSeed)
end

# minSeed = seeds.min() # Part 1

# Part 2

minSeed = (seeds.select.with_index { |_, i| i.even? }).min()

puts(minSeed)