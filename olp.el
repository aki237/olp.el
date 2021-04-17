;;; olp.el --- Open last saved the buffer position
;; Copyright (C) 2020 Akilan Elango

;; Author: Akilan Elango <akilan1997 [at] gmail.com>
;; Keywords: convenience
;; X-URL: https://github.com/aki237/olp.el
;; URL: https://github.com/aki237/olp.el
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; olp.el (open last positions) is used to restore the buffer positions for the
;; previously opened files.
;;
;;; Installation:
;;
;;   (require 'olp)
;;
;;; Use:
;; This is used to open the file with the saved last saved buffer position like
;; in modern editors.
;;
;;; Code:

;; require


;; variables
(defvar olp-list '()
  "OLP-LIST is used to store the save positions."
  )

(defvar olp-save-file (format "%s/.emacs.d/.olp-state.el" (getenv "HOME"))
  "OLP-SAVE-FILE is where the store state will be dumped to."
  )

(defun olp-write ()
  "This function is used to dump the olp state into the file olp-save-file."
  (with-temp-file olp-save-file
    (prin1 olp-list (current-buffer))))

(defun olp-init ()
  "This function is used to initialize the olp state."
  (setq olp-list
	(ignore-errors
	  (with-temp-buffer
	    (insert-file-contents olp-save-file)
	    (cl-assert (eq (point) (point-min)))
	    (read (current-buffer))))))

(defmacro olp-get-position (filename)
  "This function is used to get the last position for the passed FILENAME."
  `(alist-get ,filename olp-list 0 nil 'string-equal)
  )

(defun olp-save-hook ()
  "This function is used to update the state of opened positions."
  (progn
    (setf (olp-get-position (buffer-file-name)) (point))
    (olp-write)
    ))

(defun olp-buffer-open-hook ()
  "This function is used to restore the buffer position of an opened file."
  (goto-char (olp-get-position (buffer-file-name)))
  )

(defun olp-setup ()
  "This function is used to set up the required hooks and initialize the olp state."
    (progn
      (olp-init)
      (add-hook 'before-save-hook 'olp-save-hook)
      (add-hook 'after-change-major-mode-hook 'olp-buffer-open-hook)
      ))

(provide 'olp)
;;; olp.el ends here
