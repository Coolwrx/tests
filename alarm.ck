SinOsc x => dac;
1 => x.gain;
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
    while( fre <= high )
    {
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