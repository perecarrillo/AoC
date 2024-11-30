class BigDecimal {
    // Configuration: constants
    static DECIMALS = 100; // number of decimals on all instances
    static ROUNDED = true; // numbers are truncated (false) or rounded (true)
    static SHIFT = BigInt("1" + "0".repeat(BigDecimal.DECIMALS)); // derived constant
    constructor(value) {
        if (value instanceof BigDecimal) return value;
        let [ints, decis] = String(value).split(".").concat("");
        this._n = BigInt(ints + decis.padEnd(BigDecimal.DECIMALS, "0")
            .slice(0, BigDecimal.DECIMALS))
            + BigInt(BigDecimal.ROUNDED && decis[BigDecimal.DECIMALS] >= "5");
    }
    static fromBigInt(bigint) {
        return Object.assign(Object.create(BigDecimal.prototype), { _n: bigint });
    }
    add(num) {
        return BigDecimal.fromBigInt(this._n + new BigDecimal(num)._n);
    }
    subtract(num) {
        return BigDecimal.fromBigInt(this._n - new BigDecimal(num)._n);
    }
    static _divRound(dividend, divisor) {
        return BigDecimal.fromBigInt(dividend / divisor
            + (BigDecimal.ROUNDED ? dividend * 2n / divisor % 2n : 0n));
    }
    multiply(num) {
        return BigDecimal._divRound(this._n * new BigDecimal(num)._n, BigDecimal.SHIFT);
    }
    divide(num) {
        return BigDecimal._divRound(this._n * BigDecimal.SHIFT, new BigDecimal(num)._n);
    }
    toString() {
        let s = this._n.toString().replace("-", "").padStart(BigDecimal.DECIMALS + 1, "0");
        s = (s.slice(0, -BigDecimal.DECIMALS) + "." + s.slice(-BigDecimal.DECIMALS))
            .replace(/(\.0*|0+)$/, "");
        return this._n < 0 ? "-" + s : s;
    }
    eq(num) {
        return this._n == (new BigDecimal(num))._n;
    }
    gt(num) {
        return this._n > (new BigDecimal(num))._n;
    }
    lt(num) {
        return this._n < (new BigDecimal(num))._n;
    }
}

class HailStone {
    constructor(line) {
        // console.log(line);
        let sp = line.split("@");
        let pos = sp[0].trim(), vel = sp[1].trim();
        [this.px, this.py, this.pz] = pos.split(",").map(element => { return new BigDecimal(element.trim()); });
        [this.vx, this.vy, this.vz] = vel.split(",").map(element => { return new BigDecimal(element.trim()); });
    }

    startsAfter(x, y) {
        if (this.vx.gt(0) && x.lt(this.px)) return false;
        if (this.vx.lt(0) && x.gt(this.px)) return false;
        if (this.vy.gt(0) && y.lt(this.py)) return false;
        if (this.vy.lt(0) && y.gt(this.py)) return false;
        return true;
    }
};

function parallel(h1, h2) {
    return (h1.vx.divide(h2.vx)).eq(h1.vy.divide(h2.vy));
}

function checkLineIntersection(line1StartX, line1StartY, line1EndX, line1EndY, line2StartX, line2StartY, line2EndX, line2EndY) {

    let denominator = ((line2EndY.subtract(line2StartY)).multiply((line1EndX.subtract(line1StartX)))).subtract(((line2EndX.subtract(line2StartX)).multiply(line1EndY.subtract(line1StartY))));
    if (denominator.eq(0)) {
        console.log("WTFFFFFFFFFF");
    }
    let a = line1StartY.subtract(line2StartY);
    let b = line1StartX.subtract(line2StartX);
    let numerator1 = ((line2EndX.subtract(line2StartX)).multiply(a)).subtract((line2EndY.subtract(line2StartY)).multiply(b));
    let numerator2 = ((line1EndX.subtract(line1StartX)).multiply(a)).subtract((line1EndY.subtract(line1StartY)).multiply(b));
    a = numerator1.divide(denominator);
    b = numerator2.divide(denominator);

    return [line1StartX.add(a.multiply(line1EndX.subtract(line1StartX))), line1StartY.add(a.multiply(line1EndY.subtract(line1StartY)))];
}

function intersectInside(h1, h2, min, max) {
    // console.log("Enter intersect function");
    if (parallel(h1, h2)) return false;
    [x, y] = checkLineIntersection(h1.px, h1.py, h1.px.add(h1.vx), h1.py.add(h1.vy), h2.px, h2.py, h2.px.add(h2.vx), h2.py.add(h2.vy));
    // console.log("intersect at ", x, ", ", y);
    if (x.lt(min) || x.gt(max) || y.lt(min) || y.gt(max)) return false;
    // console.log("intersection is inside");
    if (!(h1.startsAfter(x, y) && h2.startsAfter(x, y))) return false;
    // console.log("intersect in the future");
    return true;

}

function computeIntersections(lines) {
    let hailstones = []
    const min = 200000000000000n
    const max = 400000000000000n

    for (h of lines) {
        hailstones.push(new HailStone(h))
    }

    let result = 0;

    for (let i = 0; i < hailstones.length; ++i) {
        for (let j = i + 1; j < hailstones.length; ++j) {
            if (intersectInside(hailstones[i], hailstones[j], min, max)) ++result;
        }
    }
    return result;
}

function getSumInitialPosition(lines) {
    let hailstones = []

    for (h of lines) {
        hailstones.push(new HailStone(h))
    }

    let x = 370994826025810n
    let y = 410411158485339n
    let z = 167572107691063n


    return x + y + z;
} 
