
class Workflow {
    
    companion object {
        var workflows = mutableMapOf<String, Workflow> ()
    }

    val rules: List<Rule>
    val name : String
    
    override fun toString() = "Workflow($name, ${rules.joinToString()})"
    
    constructor(dataIn: String) {
        var data = dataIn
        val nameIdx = data.indexOf("{")
        name = data.take(nameIdx)
        data = data.drop(nameIdx + 1)
        data = data.dropLast(1)
        // println(name)
        rules = data.split(",").map{ Rule(it) }
        // println(rules)
        
        workflows[name] = this
    }
    
    // True if it's Accept, false if it's Reject
    constructor(data : Boolean) {
        
        name = if (data) "A" else "R"
        
        rules = emptyList()
        
        workflows[name] = this
    }
    
    fun accepts(p : Part) : Boolean {
        for (r in rules) {
            val res : String? = r.evaluate(p)
            if (res != null) {
                if (res.compareTo("A") == 0) {
                    return true
                }
                else if (res.compareTo("R") == 0) {
                    return false
                }
                return workflows[res]!!.accepts(p)
            }
        }
        return false
    }
    
    private fun computeCombinations(low: HashMap<Char, Int>, high : HashMap<Char, Int>) : Long {
        val x = (high['x']!! - low['x']!!).toLong() + 1
        val m = (high['m']!! - low['m']!!).toLong() + 1
        val a = (high['a']!! - low['a']!!).toLong() + 1
        val s = (high['s']!! - low['s']!!).toLong() + 1
        
        // println("x: $x, m: $m, a: $a, s: $s")
        
        return x * m * a * s
    }
    
    fun computeRangeAccepted(low : HashMap<Char, Int>, high : HashMap<Char, Int>) : Long {
        
        // println("[ComputeRangeAccepted] " + name)
        
        if (name.compareTo("A") == 0) return computeCombinations(low, high)
        else if (name.compareTo("R") == 0) return 0
        
        // println("Is not A or R")
        
        var sum : Long = 0
        for (r in rules) {
            if (r.isSimple) {
                sum += workflows[r.nextWorkflow]!!.computeRangeAccepted(low, high)
                break
            }
            else {
                val l = r.letter!!
                if (r.isGreater!!) {
                    val splitNumber = r.split!!
                    if (splitNumber >= high[l]!!) {
                        // Always rejected
                        // sum += workflows[r.nextWorkflow]!!.computeRangeAccepted(low, high)
                        continue
                    }
                    else if (splitNumber < low[l]!!) {
                        // All accepted
                        sum += workflows[r.nextWorkflow]!!.computeRangeAccepted(low, high)
                        break
                        // sum += computeCombinations(low, high)
                    }
                    else {
                        var low2 = HashMap(low)
                        low2[l] = splitNumber + 1
                        val high2 = HashMap(high)
                        sum += workflows[r.nextWorkflow]!!.computeRangeAccepted(low2, high2)
                        
                        
                        // val low1 = HashMap(low)
                        // var high1 = HashMap(high)
                        // high1[l] = splitNumber
                        high[l] = splitNumber
                        
                        // sum += computeCombinations(low2, high2)
                        //println("Splitting $l > into ${low1[l]}, ${high1[l]} and ${low[l]}, ${high[l]}")
                    }
                }
                else {
                    val splitNumber = r.split!!
                    if (splitNumber <= low[l]!!) {
                        // sum += workflows[r.nextWorkflow]!!.computeRangeAccepted(low, high)
                        continue
                    }
                    else if (splitNumber > high[l]!!) {
                        // All accepted
                        // sum += computeCombinations(low, high)
                        sum += workflows[r.nextWorkflow]!!.computeRangeAccepted(low, high)
                        break
                    }
                    else {
                        val low1 = HashMap(low)
                        var high1 = HashMap(high)
                        high1[l] = splitNumber - 1
                        sum += workflows[r.nextWorkflow]!!.computeRangeAccepted(low1, high1)
                        // sum += computeCombinations(low1, high1)
                        // var low2 = HashMap(low)
                        // low2[l] = splitNumber
                        // val high2 = HashMap(high)
                        low[l] = splitNumber
                        //println("Splitting $l < into ${low[l]}, ${high[l]} and ${low2[l]}, ${high2[l]}")
                    }
                }
            }
        }
        return sum
    }
    
}

class Part {
    var x : Int = 0
    var m : Int = 0
    var a : Int = 0
    var s : Int = 0
    
    override fun toString() = "Part(x: $x, m: $m, a: $a, s: $s)"
    
    constructor (data: String) {
        var str = data
        str = str.drop(1)
        str = str.dropLast(1)
        
        val xmas = str.split(",").map { it.drop(2).toInt() }
        x = xmas[0]
        m = xmas[1]
        a = xmas[2]
        s = xmas[3]
    }
}

class Rule {
    
    var operation : (Part) -> Boolean
    var nextWorkflow : String
    var isSimple : Boolean
    var letter : Char?
    var split : Int?
    var isGreater : Boolean?
    
    override fun toString() = "Rule($operation, $nextWorkflow)"
    
    constructor(data: String) {
        if (!data.contains(":")) {
            operation = { true } 
            nextWorkflow = data
            split = null
            isGreater = null
            letter = null
            isSimple = true
        }
        else {
            val (op, next) = data.split(":")
            nextWorkflow = next
            operation = this.computeOperation(op)
            
            isSimple = false
            var str = op
            letter = str.take(1).single()
            str = str.drop(1)
            val ops : Char = str.take(1).single()
            str = str.drop(1)
            val num : Int = str.toInt()
            
            isGreater = ops == '>'
            
            split = num
        }
        
    }
    
    private fun computeOperation(data : String): (Part) -> Boolean {
        var str = data
        val letter : Char = str.take(1).single()
        str = str.drop(1)
        val op : Char = str.take(1).single()
        str = str.drop(1)
        val num : Int = str.toInt()
        if (op == '>') {
            when (letter) {
                'x' -> return { p : Part -> p.x > num }
                'm' -> return { p : Part -> p.m > num }
                'a' -> return { p : Part -> p.a > num }
                else -> return { p : Part -> p.s > num }
            }
        }
        else {
            when (letter) {
                'x' -> return { p : Part -> p.x < num }
                'm' -> return { p : Part -> p.m < num }
                'a' -> return { p : Part -> p.a < num }
                else -> return { p : Part -> p.s < num }
            }
        }
    }
    
    fun evaluate(x: Part): String? {
        if (operation(x)) return nextWorkflow
        else return null
    }
}


fun main(args: Array<String>) {
    var line = readln()
    var start : Workflow? = null
    
    while (line != "") {
        var w = Workflow(line)
        if (line.take(2).compareTo("in") == 0) {
            start = w
        }
        line = readln()
    }
    
    
    
    Workflow(true)
    Workflow(false)
    val low = HashMap<Char, Int> ()
    low['x'] = 1
    low['m'] = 1
    low['a'] = 1
    low['s'] = 1
    val high = HashMap<Char, Int> ()
    high['x'] = 4000
    high['m'] = 4000
    high['a'] = 4000
    high['s'] = 4000
    
    val sum = start!!.computeRangeAccepted(low, high)
    
    /*line = readln() // Part One
    var sum : Int = 0
    
    while (line != "") {
        val p = Part(line)
        
        if (start!!.accepts(p)) {
            sum += p.x + p.m + p.a + p.s
        }
        
        line = readln()
    }*/
    println("Sum of accepted parts: $sum")
}