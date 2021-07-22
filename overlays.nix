self: super:

{
  nerdfonts = super.nerdfonts.override { fonts = [ "VictorMono" ]; };

  pulseaudio = super.pulseaudio.override {
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };
}
