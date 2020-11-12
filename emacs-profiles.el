;;; .emacs-profiles.el --- Configuration file for chemacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Jeff Ramnani

;; Author: Jeff Ramnani <jeff@jefframnani.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a configuration file for the chemacs library.
;; https://github.com/plexus/chemacs
;;
;; Chemacs allows you to switch between different Emacs configurations.
;; e.g. Spacemacs, Doom, Prelud, and your own custom config.

;;; Code:

;; Use full paths to each emacs profile directory.
;; Don't use symlinks for this right now. Keep it explicit and easier to debug.
(("default" . ((user-emacs-directory . "~/code/profile/emacs.d")))
 ("doom" . ((user-emacs-directory . "~/code/doom-emacs")
            (env .  (("DOOMDIR" . "~/code/profile/doom.d")))))
 ("spacemacs" . ((user-emacs-directory . "~/code/spacemacs")
                 (env . (("SPACEMACSDIR" . "~/code/profile/spacemacs.d"))))))

(provide '.emacs-profiles)
;;; .emacs-profiles.el ends here
