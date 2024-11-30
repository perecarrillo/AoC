import random

def find(parents, i):
    r = i
    while r in parents:
        r = parents[r]
    while i in parents:
        p = parents[i]
        parents[i] = r
        i = p
    return i

def karger(n, edges):
    edges = list(edges)
    random.shuffle(edges)
    parents = {}
    for i, j in edges:
        if n <= 2:
            break
        
        i = find(parents, i)
        j = find(parents, j)
        if i == j:
            continue
        
        parents[i] = j
        n -= 1
        
    return parents, sum(find(parents, i) != find(parents, j) for (i, j) in edges)

def main():
    edges = set()
        
    vertices = {}
    file = open("25.realin", 'r')
    lines = file.readlines()
    vid = 0
    for line in lines: 
        [v, oth] = line.strip().split(":")
        v = v.strip()
        if not (v in vertices.keys()):
            vertices[v] = vid
            vid += 1
        for o in oth.strip().split(" "):
            o = o.strip()
            if not (o in vertices.keys()):
                vertices[o] = vid
                vid += 1
            edges.add((vertices[v], vertices[o]))
            
    n = len(vertices.keys())
    
    print(f"{n} vertices: {vertices}")
        
    while True:
        p, m = karger(n, edges)
        if m == 3:
            best = m
            # print(f"Size p: {len(p)}")
            # print(p)
            g1 = []
            g2 = []
            vg1 = None
            vg2 = None
            
            for k, v in p.items():
                if vg1 == None:
                    vg1 = v
                    g1.append(v)
                    g1.append(k)
                elif vg2 == None:
                    vg2 = v
                    g2.append(v)
                    g2.append(k)
                elif vg1 == v:
                    g1.append(k)
                elif vg2 == v:
                    g2.append(k)
                    
            if len(g1) + len(g2) == n:
                break
    
    print(g1)
    print(g2)
    print(len(g1) * len(g2))


if __name__ == "__main__":
    main()