function awsprof { export AWS_PROFILE=$1 }
function _awsprof { compadd $(cat ~/.aws/credentials | grep "\[*\]" | sed -E "s/\[|\]//g")}
compdef _awsprof awsprof

function viberjwt {
  generator_path="/Users/idok/work/VBE-X-AUTH-MAP/generator"
  tokens_path="/Users/idok/work/viberTokens/"
  echo
  if [ -f $1 ]; then
    token=$(cat $1 | grep AuthToken= | sed "s/AuthToken=//g" )
  else
    echo -n "int or prod or profql: "; read env
    mkdir -p $tokens_path/$env/$1
    pushd $generator_path > /dev/null
      ./vbe_java_generator.sh $1 > $tokens_path/$env/$1/new.jwt || return 1
    popd > /dev/null
    token=$(cat $tokens_path/$env/$1/new.jwt | grep AuthToken= | sed "s/AuthToken=//g")
  fi
  echo Token=$token

  token_data=$(jwt decode $token)

  epoch=$(echo $token_data | grep exp | grep -Eo "\d*")
  parsed_date=$(date -r $epoch)

  now=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
  epoch_expire=$(($epoch - $now))
  epoch_day=86400
  echo
  echo Date=$parsed_date
  echo
  echo ExpireIn=$(($epoch_expire/$epoch_day))
  echo $token_data
}

function awsall {
  export AWS_PAGER=""
  for i in `aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text|sort -r`; do
    echo "------"
    echo $i
    echo "------"
    echo -e "\n"
    if [ `echo "$@"|grep -i '\-\-region'|wc -l` -eq 1 ]; then
        echo "You cannot use --region flag while using awsall"
        break
    fi
    aws $@ --region $i
    sleep 2
  done
  trap "break" INT TERM
}


function ecrLogin {
  if [ "$#" -lt "1" ]; then
    echo "ERROR: add region"
    return 1
  fi
  password=$(aws ecr get-login-password --region $1) || return 1
  docker login --username AWS --password "$password" 214144294495.dkr.ecr.$1.amazonaws.com   
}

function cd {
  if [[ -d ./venv ]]; then
    deactivate
  fi

  builtin cd $@

  if [[ -d ./venv ]]; then
    . ./venv/bin/activate
  fi
}
