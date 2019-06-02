SinOsc x => dac;
0 => x.gain;
float i, ix, low, high, fre;
1 => i;
2 => ix;
/*
while( true ) {
    i + ix => i;
    ix * (-1) => ix;
    1000::ms => now;
    0.8 => x.gain;
    440 * i => x.freq;
    }
*/
750 => low;
1000 => high;

while(true){
    low => fre;
    0 => i;
    0 => ix;
    1/(( high - low )/10) => ix;
    while( fre <= high )
    {
        i + ix => x.gain;
        fre => x.freq;
        fre + 10 => fre;
        1::ms => now;
    }
    500::ms => now;
    while( fre >= low )
    {
        fre => x.freq;
        fre - 10 => fre;
        1::ms => now;
    }
    500::ms => now;
}