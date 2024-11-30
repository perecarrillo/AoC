#import <Foundation/Foundation.h>


// n1 <= n2
bool leq(NSString *n1, NSString *n2) {
    if (n1.length < n2.length) return true;
    if (n1.length > n2.length) return false;


    int i;


    for (i = 0; i < n1.length; ++i) {
        if ((int) ([n1 characterAtIndex:i] - '0') < (int) ([n2 characterAtIndex:i] - '0')) return true;
        if ((int) ([n1 characterAtIndex:i] - '0') > (int) ([n2 characterAtIndex:i] - '0')) return false;
    }
    return true;
}

NSString *increment(NSString *n1) {
    int position = n1.length - 1;
    int newDigit = (int) ([n1 characterAtIndex:position] - '0') + 1;
    NSString *result = n1;
    while (newDigit > 9) {
        if (position <= 0) {
            result = [result stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@"0"];
            result = [NSString stringWithFormat:@"1%@", result];
            return result;
        }
        result = [result stringByReplacingCharactersInRange:NSMakeRange(position,1) withString:@"0"];
        --position;
        newDigit = (int) ([n1 characterAtIndex:position] - '0') + 1;
    }
    NSString *stringDigit = [NSString stringWithFormat:@"%d", newDigit];
    result = [result stringByReplacingCharactersInRange:NSMakeRange(position,1) withString:stringDigit];
    return result;
}

NSString *add(NSString *n1, NSString *n2) {
    NSString *i = @"1";
    NSString *result = n2;
    while (leq(i, n1)) {
        // NSLog(@"Incrementing %@", i);
        result = increment(result);
        i = increment(i);
    }
    return result;
}


int main (int argc, const char * argv[])
{
   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

   // int size = 3;
   // int times[] = {7, 15, 30};
   // int dist[] = {9, 40, 200};
   // Part one
   // int size = 4;
   // int times[] = {56, 97, 78, 75};
   // int dist[] = {546, 1927, 1131, 1139};
   // long i = 0;
   // int result = 1;
   // for (i = 0; i < size; ++i) {
   //     int j;
   //     long long ways = 0;
   //     for (j = times[i]; j >= 0; --j) {
   //         int run = (times[i] - j) * j;
   //         int foo = times[i] - j;
   //         // NSLog(@"Run %i, waiting %i, total distance: %i", i, foo, run);
   //         if (run > dist[i]) ++ways;
   //     }
   //     NSLog(@"Parcial result: %i", ways);
   //     result *= ways;
   // }
   // NSLog(@"Result: %d", result);
 

    // Part two




    /** ###################################################################################################################################
    Pensava que no cabia en un unsigned long long... Aixi q tocava implementar el meu propi long long. Si que cabia al final :(
    #######################################################################################################################################*/




    // NSString *time = @"56977875"; // {71530};
    // NSString *dist = @"546192711311139"; // {940200}; 

    // NSLog(add(@"15000000", @"150"));

    // // if (leq(times, dist)) {
    // //     NSLog(@"LEQ");
    // // }
    // // else NSLog(@"GREATER");

    // // int i = 0;
    // // NSString *num = @"0";
    // // for (i = 0; i < 1000; ++i) {
    // //     num = increment(num);
    // //     NSLog(num);
    // // }

    // NSString * ways = @"0";

    // NSString * i = @"0";
    // for (; leq(i, time); increment(i)) {

    // }

    unsigned long long time = 56977875;
    unsigned long long dist = 546192711311139;

    // unsigned long long time = 71530;
    // unsigned long long dist = 940200;

    long long j;
    long long ways = 0;
    for (j = time; j >= 0; --j) {
    long long run = (time - j) * j;
    if (run > dist) ++ways;
    }
    NSLog(@"Result: %llu", ways);

    [pool drain];
    return 0;
}















