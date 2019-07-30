#!/bin/bash
jupyter notebook --ip='*' --NotebookApp.token='' --NotebookApp.password='' --allow-root --no-browser $@ &> /dev/null &
/usr/bin/xterm &> /dev/null &
/bin/bash
