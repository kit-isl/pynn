#!/bin/bash

export OMP_NUM_THREADS=8

if lscpu | grep -q avx2; then
    extra_args+=(--int8)
fi
if [[ ${SPACE+y} ]]; then
    extra_args+=(--space "$SPACE")
fi
if [[ ${EXTRA_ARGS+y} ]]; then
    extra_args+=($EXTRA_ARGS)
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
    --punct-dic "/model/punct.dic" \
    --punct-voc "/model/punct-voc.json" \
    --device "${DEVICE:-cpu}" \
    --beam-size "${BEAMSIZE:-6}" "${extra_args[@]}"
