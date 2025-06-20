{
  ...
}:
{
  programs.wofi = {
    enable = true;
    style = ''
      * {
        font-family: Noto, sans-serif;
        font-size: 24px;
      }
      window {
        margin: 0px;
        border: 1px solid #928374;
        background-color: #002b36;
      }
      #input {
        margin: 5px;
        border: none;
        color: #839496;
        background-color: #073642;
      }
      #inner-box {
        margin: 5px;
        border: none;
        background-color: #002b36;
      }
      #outer-box {
        margin: 5px;
        border: none;
        background-color: #002b36;
      }
      #scroll {
        margin: 0px;
        border: none;
      }
      #text {
        margin: 5px;
        border: none;
        color: #839496;
      }
      #entry:selected {
        background-color: #073642;
      }
    '';
  };
}
