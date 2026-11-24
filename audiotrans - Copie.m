% Entry point for a single transmission using the supplied framework.
clear; close all; clc;
c=config_ofdm(); [ber,out]=run_link(c); plot_channel(out,'Single transmission');
