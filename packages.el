;;; packages.el --- Idris2 Layer packages File for Spacemacs
;;
;; Idris2 Layer package adapted from Idris Layer package
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: Timothy Jones <tim@zmthy.net>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


(setq idris2-packages
      '(company
        idris2-mode
        golden-ratio
        popwin
        ))

(defun idris2/post-init-company ()
  (spacemacs|add-company-backends
    :backends company-capf
    :modes idris2-mode idris2-repl-mode))

(defun idris2/init-idris2-mode ()
  (use-package idris2-mode
    :defer t
    :init (spacemacs/register-repl 'idris2-mode 'idris2-repl "idris2")
    :config
    (progn
      (defun spacemacs/idris2-load-file-and-focus (&optional set-line)
        "Pass the current buffer's file to the REPL and switch to it in
`insert state'."
        (interactive "p")
        (idris2-load-file set-line)
        (idris2-pop-to-repl)
        (evil-insert-state))

      (defun spacemacs/idris2-load-forward-line-and-focus ()
        "Pass the next line to REPL and switch to it in `insert state'."
        (interactive)
        (idris2-load-forward-line)
        (idris2-pop-to-repl)
        (evil-insert-state))

      (defun spacemacs/idris2-load-backward-line-and-focus ()
        "Pass the previous line to REPL and switch to it in `insert state'."
        (interactive)
        (idris2-load-backward-line)
        (idris2-pop-to-repl)
        (evil-insert-state))

      ;; prefix
      (spacemacs/declare-prefix-for-mode 'idris2-mode "mb" "idris2/build")
      (spacemacs/declare-prefix-for-mode 'idris2-mode "mi" "idris2/editing")
      (spacemacs/declare-prefix-for-mode 'idris2-mode "mh" "idris2/documentation")
      (spacemacs/declare-prefix-for-mode 'idris2-mode "ms" "idris2/repl")
      ;; (spacemacs/declare-prefix-for-mode 'idris2-mode "mm" "idris2/term")

      (spacemacs/set-leader-keys-for-major-mode 'idris2-mode
        ;; Shorthands: rebind the standard evil-mode combinations to the local
        ;; leader for the keys not used as a prefix below.
        "c" 'idris2-case-dwim
        "d" 'idris2-add-clause
        "l" 'idris2-make-lemma
        "p" 'idris2-proof-search
        "r" 'idris2-load-file
        "t" 'idris2-type-at-point
        "w" 'idris2-make-with-block
        "n" 'idris2-next-error
        "p" 'idris2-previous-error

        ;; ipkg.
        "bc" 'idris2-ipkg-build
        "bC" 'idris2-ipkg-clean
        "bi" 'idris2-ipkg-install
        "bp" 'idris2-open-package-file

        ;; Interactive editing.
        "ia" 'idris2-proof-search
        "ic" 'idris2-case-dwim
        "ie" 'idris2-make-lemma
        ;; "im" 'idris2-add-missing
        ;; "ir" 'idris2-refine
        "is" 'idris2-add-clause
        "iw" 'idris2-make-with-block

        ;; Documentation.
        ;; "ha" 'idris2-apropos
        "hd" 'idris2-docs-at-point
        "hs" 'idris2-type-search
        ;; "ht" 'idris2-type-at-point
        "hw" 'idris2-jump-to-def
        "hj" 'idris2-jump-to-def-same-window

        ;; Active term manipulations.
        ;; "mn" 'idris2-normalise-term
        ;; "mi" 'idris2-show-term-implicits
        ;; "mh" 'idris2-hide-term-implicits
        ;; "mc" 'idris2-show-core-term

        ;; REPL
        ;; "'"  'idris2-repl
        "sb" 'idris2-load-file
        "sB" 'spacemacs/idris2-load-file-and-focus
        ;; "si" 'idris2-repl
        "sn" 'idris2-load-forward-line
        "sN" 'spacemacs/idris2-load-forward-line-and-focus
        ;; "sp" 'idris2-load-backward-line
        "sP" 'spacemacs/idris2-load-backward-line-and-focus
        "ss" 'idris2-pop-to-repl
        ;; "sq" 'idris2-quit
        )))

  ;; To suppress auto-indentation
  (add-to-list 'spacemacs-indent-sensitive-modes 'idris2-mode)

  ;; To bind TAB to the indentation command for all Idris2 buffers
  (add-hook 'idris2-mode-hook 'turn-on-idris2-simple-indent)

  ;; open special buffers in motion state so they can be closed with ~q~
  (evil-set-initial-state 'idris2-compiler-notes-mode 'motion)
  (evil-set-initial-state 'idris2-hole-list-mode 'motion)
  (evil-set-initial-state 'idris2-info-mode 'motion))

(defun idris2/pre-init-golden-ratio ()
  (spacemacs|use-package-add-hook golden-ratio
    :post-config
    (dolist (x '("*idris2-notes*" "*idris2-holes*" "*idris2-info*"))
      (add-to-list 'golden-ratio-exclude-buffer-names x))))

(defun idris2/pre-init-popwin ()
  (spacemacs|use-package-add-hook popwin
    :post-config
    (push '("*idris2-notes*" :dedicated t :position bottom :stick t :noselect nil :height 0.4)
          popwin:special-display-config)
    (push '("*idris2-holes*" :dedicated t :position bottom :stick t :noselect nil :height 0.4)
          popwin:special-display-config)
    (push '("*idris2-info*" :dedicated t :position bottom :stick t :noselect nil :height 0.4)
          popwin:special-display-config)))
