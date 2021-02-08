## Task Description:
Write a ruby script that receives a file containing log data as an argument
e.g ./parser.rb webserver.log and returns following info

- list of webpages with most page views ordered from most pages views to less page views
        
        /home 90 visits
        /index 80 visits 
        etc...
- unique page views also ordered
        
        /about/2 8 unique views
        /index 5 unique views 
        etc...

## How To Install
``` 
git clone {repository_url} web_log_parser
cd web_log_parser
bundle install
``` 


## How To Run App
``` 
./bin/web_log_parser {args}
```

## How To Run Test
```
bundle exec rspec spec
```

## Approach Description
```
/bin folder handles user interaction - calls command line validations and shows errors to user
/cli folder handles integrations with cli - reads parameters, validates and calls parser
/lib handles actual parsing of file and storing parsed data to memory
/spec folder  stores all the tests

app receives 2 parameters
    option - [-f --full -r --relative]
    file - full or relative path of file
    
from the file app reads each line, parses it and passes is to log storage, where it is grouped and saved
in memory, after parsing is finished, app retrieves ordered data from storage and shows it to user
```

## Possible Improvements
```
as log files contain ip address we can extract more information based on ip
like country where request was made from. Also we can add choice to provide output file
location and store ordered data in this file instead of showing it in console.

Also new validations for unexpected log entries may be added, like validation for correct ip address,
validation for correct url type to exclude query params for example.
```