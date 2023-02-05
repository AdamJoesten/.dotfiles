function dotfiles-backup --wraps=mkdir\ -p\ .dotfiles-backup\ \&\&\ dotfiles\ checkout\ 2\>\&1\ \|\ grep\ -E\ \"\\s+\\.\"\ \|\ awk\ \{\'print\ \'\}\ \|\ xargs\ -I\{\}\ mv\ \{\}\ .dotfiles-backup/\{\} --description alias\ dotfiles-backup=mkdir\ -p\ .dotfiles-backup\ \&\&\ dotfiles\ checkout\ 2\>\&1\ \|\ grep\ -E\ \"\\s+\\.\"\ \|\ awk\ \{\'print\ \'\}\ \|\ xargs\ -I\{\}\ mv\ \{\}\ .dotfiles-backup/\{\}
  mkdir -p .dotfiles-backup && dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print '} | xargs -I{} mv {} .dotfiles-backup/{} $argv
        
end
