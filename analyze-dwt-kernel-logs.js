#!/usr/bin/node --harmony
'use strict';
import { createReadStream, createWriteStream } from 'node:fs';
import readline from 'node:readline';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

const state = {
    started: false,
    accPause: 0,    // jiffies of accumulated pause before dirty another page
    csv: null,
};

const argv = yargs(hideBin(process.argv))
    .argv;

const infile = argv._[0];

if (! infile) {
    console.error('no input file');
    process.exit(1);
}

const rl = readline.createInterface({
    input: infile == '-' ? process.stdin : createReadStream(infile),
});

state.csv = createWriteStream('kernel-dwt-events.csv');
state.csv.write('Time,Event,Value\n');

rl.on('close', () => {
    state.csv.end();
});
rl.on('line', line => {
    line = line.trim();
    const ma = line.match(/\[\s*(\d+\.\d+)\s*\] \[DWT\] (.*)/);
    if (ma)
        onLine(state, parseFloat(ma[1]), ma[2]);
});

/*---------------------------------------------------------------------------*/

function onLine(state, time, msg)
{
    var ma;

    if (msg.match(/^balance_dirty_pages\(/)) {
        state.accPause = 0;
        state.started = true;
    }

    if (! state.started) return;
    
    if ((ma = msg.match(/^io_schedule_timeout\((\d+)\)/))) {
        state.accPause += parseInt(ma[1]);
        state.csv.write(`${time.toFixed(3)},AccPause,${state.accPause}\n`);
    } else if ((ma = msg.match(/^nr_dirty=(\d+)/)))
        state.csv.write(`${time.toFixed(3)},AccDirty,${parseInt(ma[1])}\n`);
}
