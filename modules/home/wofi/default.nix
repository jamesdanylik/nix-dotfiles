{ ... }: {
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
    };
    style = ''
      * {
        font-family: NotoMono NF;
      }

      window, #input {
        background-color: #1a1b26;
        color: #c0caf5;
      }

      #entry:selected {
        background-color: #283457;
        color: #c0caf5;
      }
    '';
  };
}
