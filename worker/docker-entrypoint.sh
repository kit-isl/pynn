#!/bin/bash

export OMP_NUM_THREADS=8

if lscpu | grep -q avx2; then
    INT8=y
fi

pythonCMD="python -u -W ignore"
$pythonCMD worker.py \
    --server "${MEDIATOR:-i13srv30.ira.uka.de}" \
    --port "${PORT:-60019}" \
    --name "asr-${LANG:-en-EU}" \
    --fingerprint "${LANG:-en-EU}" \
    --outfingerprint "${LANG:-en-EU}" \
    --inputType "audio" \
    --outputType "${outputType:-text}" \
    --dict "/model/bpe4k.dic" \
    --model "/model/s2s-lstm.dic" \
    --punct "/model/punct.dic" \
    --device "${DEVICE:-cpu}" \
    --beam-size "${BEAMSIZE:-6}" ${INT8:+--int8}
