# frozen_string_literal: true

admin_user = User.find_by(email: 'admin@melon.com')

# Create sample movies
# rubocop:disable Layout/LineLength
FactoryBot.create(:movie,
                  title: 'The Shawshank Redemption',
                  description: 'The Shawshank Redemption is a highly acclaimed drama film released in 1994 and directed by Frank Darabont. It is based on Stephen King\'s novella "Rita Hayworth and Shawshank Redemption." The film follows the story of Andy Dufresne, a banker who is wrongfully convicted of murdering his wife and her lover. Andy is sentenced to life imprisonment at Shawshank State Penitentiary, where he faces the harsh realities of prison life. Despite the challenges, he maintains his innocence and retains a sense of hope. Inside the prison, Andy forms a close friendship with Ellis "Red" Redding, a long-term inmate who becomes his confidant and mentor. As time passes, Andy utilizes his financial expertise to help the prison staff and develops a reputation among both the inmates and the guards. He manages to create a small library within the prison and even helps to improve the prison\'s financial records. Andy\'s resilience and determination inspire hope among his fellow inmates, and he becomes a symbol of strength within Shawshank. Throughout the film, themes of friendship, loyalty, and the search for redemption are explored. The story also delves into the corrupt nature of the prison system and the injustices that can occur within it. Andy\'s ultimate goal is to escape from Shawshank and prove his innocence. He meticulously plans his escape over many years, using his intelligence and resourcefulness to overcome numerous obstacles. "The Shawshank Redemption" is widely regarded as one of the greatest films ever made, known for its powerful storytelling, exceptional performances by Tim Robbins and Morgan Freeman, and its exploration of hope and the human spirit in the face of adversity.',
                  release_date: '1994-09-23',
                  duration: 142,
                  cover_img: 'https://upload.wikimedia.org/wikipedia/en/8/81/ShawshankRedemptionMoviePoster.jpg',
                  user_id: admin_user.id
                 )

FactoryBot.create(:movie,
                  title: 'Inception',
                  description: 'Inception is a mind-bending science fiction film released in 2010 and directed by Christopher Nolan. The story revolves around Dom Cobb, a skilled thief who specializes in extracting valuable information from people\'s dreams. Cobb is offered a chance to regain his old life by performing the impossible task of "inception" – planting an idea in someone\'s mind instead of stealing one. As Cobb and his team delve deeper into the layers of dreams, they face unpredictable challenges and encounter a dangerous adversary. The film explores the concept of dreams within dreams, blurring the lines between reality and the subconscious. Inception is known for its intricate plot, stunning visual effects, and thought-provoking themes about perception, memory, and the power of the mind.',
                  release_date: '2010-07-16',
                  duration: 148,
                  cover_img: 'https://upload.wikimedia.org/wikipedia/en/2/2e/Inception_%282010%29_theatrical_poster.jpg',
                  user_id: admin_user.id
                 )

# rubocop:enable Layout/LineLength
