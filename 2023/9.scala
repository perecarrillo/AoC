import scala.io.StdIn.readLine


object MyClass {    
    def nextElement(elem: Array[Int]):Int = {

        if (elem.forall(_ == elem(0))) {
            // println("Found number: " + elem(0));
            return elem(0);
        }

        var i = 0;
        var sums = Array[Int]();
        for (i <- 0 to elem.length - 2) {
            // print(elem(i) + "\n");
            sums :+= elem(i + 1) - elem(i);
        }
        // println("Sums: " + sums.mkString(", "));

        var next = nextElement(sums);
        // println("Next number: " + (elem.last + next))

        
        // return elem.last + next; // First part
        return elem(0) - next; // Second part
    }

    def main(args: Array[String]) {
        var line = readLine();
        var result = 0;
        while (line != "DONE") {
            if (line != "") {
                var elem = line.trim().split(" ").map((i: String) => i.toInt);
                val next = nextElement(elem);
                // println("Next number to add: " + next);
                result = result + next;
            }
            line = readLine();
        }
        print("Result " + result + "\n");
    }
}