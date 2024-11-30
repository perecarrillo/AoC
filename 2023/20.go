package main

import (
    "fmt"
    "bufio"
    "os"
    "strings"
    "slices"
	"math/big"
)

type Module struct {
    name string
    next []string
    isFlipFlop bool
    isOn bool
    inputs []string
    lastPulse []bool
}

type Pulse struct {
    from string
    to string
    isHigh bool
}

func Map(vs []string, f func(string) string) []string {
    vsm := make([]string, len(vs))
    for i, v := range vs {
        vsm[i] = f(v)
    }
    return vsm
}

func push(queue[]Pulse, element Pulse) []Pulse {
  queue = append(queue, element)
  return queue
}

func last(queue[]Pulse) Pulse {
    return queue[0]
}

func pop(queue[]Pulse) []Pulse {
  return queue[1:]
}

func isEmpty(queue[] Pulse) bool {
    return len(queue) == 0
}

func LCM(a, b *big.Int) *big.Int {
	result := new(big.Int)
	result.Mul(a, b)
	gcd := new(big.Int)
	gcd.GCD(nil, nil, a, b)
	result.Div(result, gcd)

	return result
}


func MultipleLCM(a, b *big.Int, integers ...*big.Int) *big.Int {
	result := LCM(a, b)

	for i := 0; i < len(integers); i++ {
			result = LCM(result, integers[i])
	}

	return result
}

func main() {
    
    file, _ := os.Open("./20.realin")
    
    scanner := bufio.NewScanner(file)
    
    var modules map[string]Module
    modules = make(map[string]Module)
    
    for scanner.Scan() {
        line := scanner.Text()
        // fmt.Println(line)
        
        sp := strings.Split(line, " -> ")
        
        if (sp[0] == "broadcaster") {
            start := Module{ name: sp[0], next: Map(strings.Split(sp[1], ","), strings.TrimSpace), isFlipFlop: false }
            modules[start.name] = start
        } else {
            m := Module{name: sp[0][1:], next: Map(strings.Split(sp[1], ","), strings.TrimSpace), isFlipFlop: sp[0][0] == '%'}
            modules[m.name] = m
            // fmt.Println(m)
        }
    }
    
    var finalModules = make(map[string]Module)
    
    for k, v := range modules {
        var input []string
        var lastPulses []bool
        if (!v.isFlipFlop) {
            
            for k2, v2 := range modules {
                // fmt.Printf("Checking " + k + " " + k2 + "; %v contains %v ? %t \n",v2.next, k, slices.Contains(v2.next, k))
                if (slices.Contains(v2.next, k)) {
                    input = append(input, k2)
                    lastPulses = append(lastPulses, false)
                }
            }
        }
        v.inputs = input
        v.lastPulse = lastPulses
        finalModules[k] = v
    }
    
    // fmt.Println(finalModules)
    
    var lows = 0
    var highs = 0
    
    
    i := big.NewInt(1)

	ks := big.NewInt(0)
	pm := big.NewInt(0)
	dl := big.NewInt(0)
	vk := big.NewInt(0)
    // for i < 1000 { // Part One
    out:
    for {
        queue := make([]Pulse, 0)
        queue = push(queue, Pulse{from: "button", to: "broadcaster", isHigh: false})
        for !isEmpty(queue) {
            var next = last(queue)
            queue = pop(queue)
            var mod = finalModules[next.to]
            var nextPulse = next.isHigh
            var continues = true
            
            if (nextPulse) {
                highs++
            } else {
                lows++
            }
            // fmt.Println(next)
            // fmt.Println(highs, lows)
            
            
            if (mod.name == "broadcaster") {
                
            } else if (nextPulse && mod.isFlipFlop) {
                continues = false  
                
            } else if (mod.isFlipFlop) {
                mod.isOn = !mod.isOn
                nextPulse = mod.isOn
                
            } else {
                for k, v := range mod.inputs {
                    if (v == next.from) {
                        mod.lastPulse[k] = nextPulse
                    }
                }
                // fmt.Println("Module: ", mod)
                nextPulse = false // High
                for _, v := range mod.lastPulse {
                    if (!v) {
                        nextPulse = true
                        break
                    }
                }
            }
            
            if (continues) {
                for _, v := range mod.next {
                    queue = push(queue, Pulse{from: mod.name, to: v, isHigh: nextPulse})
                    if (v == "rx" && nextPulse == false) {
                        break out
                    } else if (ks.Cmp(big.NewInt(0)) == 0 && v == "ks" && nextPulse == false) {
						ks.Set(i)
					} else if (pm.Cmp(big.NewInt(0)) == 0 && v == "pm" && nextPulse == false) {
						pm.Set(i)
					} else if (dl.Cmp(big.NewInt(0)) == 0 && v == "dl" && nextPulse == false) {
						dl.Set(i)
					} else if (vk.Cmp(big.NewInt(0)) == 0 && v == "vk" && nextPulse == false) {
						vk.Set(i)
					} 
					if (ks.Cmp(big.NewInt(0)) != 0 && pm.Cmp(big.NewInt(0)) != 0 && dl.Cmp(big.NewInt(0)) != 0 && vk.Cmp(big.NewInt(0)) != 0) {
						break out
					}
                }
            }
            
            
            // Update finalModules
            finalModules[next.to] = mod
        }
		// fmt.Println(finalModules)
		// fmt.Println(finalModules["vr"])
		// fmt.Println(finalModules["vr"], " - ", finalModules["pf"], " - ", finalModules["ts"], " - ", finalModules["vk"])

        i.Add(i, big.NewInt(1))
    }
    fmt.Println("First Part: lows sent * highs sent: ", lows*highs)

	fmt.Println("ks: ", ks)
	fmt.Println("pm: ", pm)
	fmt.Println("dl: ", dl)
	fmt.Println("vk: ", vk)

	fmt.Println("Part two: LCM: ", MultipleLCM(ks, pm, dl, vk))

}