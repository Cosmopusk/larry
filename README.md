# Larry. Digital Assets Exchange Service

[![Build Status](https://travis-ci.com/finfex/larry.svg?branch=master)](https://travis-ci.com/finfex/larry)

## Specification

* [ ] All database primary keys are UUID's


## Development

> rake db:create db:migrate db:seed

Update source, basic and public rates

> rake gera:update_rates

Then look into logs/gera_*.log for logs


## Update gera migration

> rm db/migrate/*.gera.*; rake gera:install:migrations  
