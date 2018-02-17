# Configuration file for ipython.

c = get_config()

# Requires the package 'pygments-style-solarized' is installed.
try:
    import pygments_style_solarized
    c.TerminalInteractiveShell.highlighting_style = 'solarizeddark'
except ImportError as e:
    c.TerminalInteractiveShell.highlighting_style = 'monokai'
