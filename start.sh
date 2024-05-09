#!/bin/bash

mix escript.build;

echo -e "\n\nApollo 11:\n\n"

./nasa_btt 28801 '[{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]'

echo -e "\n\nMission on Mars:\n\n"

./nasa_btt 14606 '[{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]'

echo -e "\n\nPassanger ship:\n\n"

./nasa_btt 75432 '[{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]'