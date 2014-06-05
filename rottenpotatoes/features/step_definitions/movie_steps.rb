# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
  # flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
   match = /#{e1}.*#{e2}/m =~ page.body
   match.should_not be_nil
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rating|
     steps %Q{      
      When  I #{uncheck ? "uncheck" : "check"} "ratings[#{rating.strip}]"
    }
  end
end

Then /I should ?(not)? see movies with ratings: (.*)/ do |not_see, rating_list|
  rating_list.split(',').each do |rating|
     Movie.find_all_by_rating(rating.strip).each do |movie|
       steps %Q{      
        Then  I should #{not_see ? "not see" : "see"} "#{movie.title}"
       }
     end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
   Movie.all.each do |movie|
     steps %Q{      
      Then  I should see "#{movie.title}"
     }
   end
end
