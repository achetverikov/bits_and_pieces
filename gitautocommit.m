function [git_hash_string, autocommit_msg] = gitautocommit(varargin)
% GITAUTOCOMMIT Commit to git and return the current git hash
%
% [git_hash_string, autocommit_msg] = gitautocommit(commit_msg, print_autocommit_msg)
%
% This function adds everything to the repository in the current folder
% (`git add .`), checks if there any changes (via `git diff`) and (if there
% are any) commits them to the repository. Then the last commit hash is
% returned along with the autocommit message (which is empty if there were
% no changes). 
%
% Optional arguments:
% commit_msg - the message used for commit (default: current datetime)
% print_autocommit_msg - should autocommit message be printed in the
% console (true by default, accepts any value convertable to logical).

    if nargin==0
        commit_msg = datestr(datetime('now'));
    else
        commit_msg = varargin{1};
    end
    
    if nargin < 2
        print_autocommit_msg = 1;
    else
        print_autocommit_msg = logical(varagin{2});
    end
    
    % note on git commands:
    % `git diff --quiet && git diff --staged --quiet` return non-zero only if
    % there are any changes; this return status determines whether `git
    % commit` should be run
    
    [res, msg] = system(sprintf('git add .; git diff --quiet && git diff --staged --quiet || git commit -am "Autocommit %s"', commit_msg));
    
    if res~=0
        error('There was an error during autocommit. Error code: %s. Error msg:\n %s', res, msg)
    elseif strlength(msg) == 0 && print_autocommit_msg
    	fprintf(['Autocommit did not run because nothing changed.\n'])
    elseif print_autocommit_msg
    	fprintf(['Autocommit msg:\n' msg])
    end
    
    % git version
    [res, git_hash_string] = system('git rev-parse HEAD');
    
    % remove trailing newline
    git_hash_string = strtrim(git_hash_string);
    
    if res~=0
        error('There was an error during hash request. Error code: %s. Error msg:\n %s', res, git_hash_string)
    end
    