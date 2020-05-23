#!/bin/bash

PARENT_TASK_FILE=~/.co_parent_task

if ! git rev-parse --is-inside-work-tree 1> /dev/null 2> /dev/null; then
  echo "not a git repository"
  exit
fi

if git diff --name-only --cached --exit-code 1> /dev/null 2> /dev/null; then
  echo "nothing added to commit"
  exit
fi

git status

task=$(git symbolic-ref --short -q HEAD)

if [[ -f $PARENT_TASK_FILE ]]; then
  parent_task=$(cat $PARENT_TASK_FILE)
fi

if [[ -n $parent_task ]]; then
  printf 'subtask (%s) > parent task (%s): ' "${task}" "${parent_task}"
  task=$parent_task
else
  printf 'task (%s): ' "${task}"
fi

read -r confirm_task

if [[ -n $parent_task && $confirm_task -eq $task ]]; then
  task=$confirm_task

  printf 'Remove parent task? (y/n) '
  read -r -k1 remove_parent_task
  echo

  if [[ $remove_parent_task =~ ^[Yy]$ ]]; then 
    rm $PARENT_TASK_FILE
  fi
elif [[ -n $confirm_task && $confirm_task -ne $task ]]; then
  task=$confirm_task

  printf 'Save this task as parent task? (y/n) '
  read -r -k1 save_parent_task
  echo

  if [[ $save_parent_task =~ ^[Yy]$ ]]; then
    echo "$task" > $PARENT_TASK_FILE
  fi
elif [[ -n $confirm_task ]]; then
  task=$confirm_task
fi

printf "message: "
read -r message

echo
echo git commit -m "\"$task: $message\""
read -r

git commit -m "$task: $message"
echo
