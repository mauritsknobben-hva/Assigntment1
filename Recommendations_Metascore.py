import pandas as pd

#data is a dataframe
data = pd.read_csv('userReviews.csv',sep=';')
print(data.head())

#create empty dataframe with the same column names as the data
subset = pd.DataFrame(columns=data.columns.tolist())

#create subset of reviews of the movie "the amazing spider man"
subset = data[data.movieName == 'the-amazing-spider-man']
  
   
#Create the final dataframe that includes absolute and relative score for the recommendations
recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc','abs_inc'])
        
#looping all over the users that watched the same movie like me
for idx, Author in subset.iterrows():
    
    #Save each author and the ranking he gave the movie i like
    author = Author[['Author']].iloc[0]
    ranking = Author[['Metascore_w']].iloc[0]
    
    #Now i will create a dataframe that contains all the movies that were ranked by the selected author
    #In the dataframe only higher rankings than the movie i like
    #calculation of the relative ranking increase and the absolute ranking increase
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    
    #Extract the possible recommendations and calculate the absolute score and the relative score
    possible_recommendations = data[filter1 & filter2]
    print(possible_recommendations.head())
    
    possible_recommendations.loc[:,'rel_inc'] = possible_recommendations.Metascore_w/ranking
    possible_recommendations.loc[:,'abs_inc'] = possible_recommendations.Metascore_w - ranking
    
    #Append this to the recommendations df
    recommendations = recommendations.append(possible_recommendations)
    
    #Sort the recommendations in a descending order. First the relative score, then the absolute scores
    recommendations = recommendations.sort_values(['rel_inc','abs_inc'], ascending=False)
    print(recommendations.shape)
    
    #Drop the duplicates to decrease the size of the df
    recommendations = recommendations.drop_duplicates(subset='movieName', keep="first")
    print(recommendations.shape)
    
    #Write the file to a csv and print the first 50 recommendations
    recommendations.head(50).to_csv("recommendationsBasedOnMetascoreVo.csv", sep=";", index=False)
    print(recommendations.head(50))
    print(recommendations.shape)