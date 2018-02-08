# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'

user = User.new
user.username = "demo"
user.password = "password"
user.email = "demo@demo.com"
user.save

10.times do |num|
  tempuser = User.new
  tempuser.username = "test#{num}"
  tempuser.password = "password"
  tempuser.email="test#{num}@test.com"
  tempuser.save
end

PLATFORMS = {
  'PlayStation 4' => 'PS4',
  'Xbox One' => 'XB1',
  'Switch' => 'SW',
  'Xbox 360' => 'XB360',
  'PlayStation 2' => 'PS2',
  'PlayStation' => 'PS1',
  'PC' => 'PC',
  'iOS' => 'iOS',
  'iPhone/iPad' => 'iOS',
  'Game Boy Advance' => 'GBA',
  'PlayStation Vita' => 'PSV',
  'Wii' => 'Wii',
  'Wii U' => 'WU',
  '3DS' => '3DS',
  'Gamecube' => 'GC',
  'Nintendo 64' => 'N64',
  'DS' => 'DS',
  'GameCube' => 'GC',
}

PLATFORMS.each do |platform, abreviation|
  Platform.create(name: platform, abreviation: abreviation)
end

GENRES = {
  'Role-Playing' => 'RPG',

  'MOBA' => 'MOBA',
  'First-Person' => 'FPS',

  'Adventure' => 'Adventure',
  'Open-World' => 'Open-World',
  'Massively-Multiplayer' => 'MMO',
  'Real-Time' => 'RTS',
  'Sports' => 'Sports',
  'Sim' => 'Simulation',
  'Arcade' => 'Arcade',
  'Sandbox' => 'Sandbox',
  'Card Battle' => 'Card Battle',
  'Survival' => 'Survival',
  'Fighting' => 'Fighting',
  'Platformer' => 'Platformer',
  'Shooter' => 'Shooter',
  'Third-Person' => 'Third-Person',
  'Simulation' => 'Simulation',
  'RPG' => 'RPG',
  'Fantasy' => 'Fantasy',
  'Rhythm' => 'Rhythm',
  'Dancing' => 'Dancing',
  'Action' => 'Action',
  'Space' => 'Space',
  'Visual Novel' => 'Visual Novel',
  'Racing' => 'Racing',
  'Flight' => 'Flight',
  'Music' => 'Music',
  'Puzzle' => 'Puzzle',
  'Sci-Fi' => 'Sci-Fi',
  'Turn Based' => 'Turn Based',
  'Horror' => 'Horror',
  'Strategy' => 'Strategy',
  'Real Time' => "Real Time",
  'Party' => 'Party',
  'Minigames' => 'Minigames',
}

GENRES.each do |raw, processed|
  Genre.create(name: processed)
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'seeddata.csv')).scrub
csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')

csv.each_with_index do |row, idx|
  if idx == 208
    break
  end
  game = Game.new
  row
  game.title = row['title'][0...-1]

  if row['release date'].include?('@')
    game.release_date = row['release date'].gsub!('@', ',')
  else
    game.release_date = row['release date']
  end

  if row['description'].include?('@')
    game.description = row['description'].gsub!('@', ',')
  else
    game.description = row['description']
  end

  game.image_url = row['image_url']
  game.amazon_url = row['amazon url']
  game.rating = row['rating']

  developer = Developer.find_by(name: row['developer'])
  if developer
    game.developer_id = developer.id
  else
    developer = Developer.create(name: row['developer'])
    game.developer_id = developer.id
  end
  if !game.save
    p game
    p game.errors.full_messages
  end

  PLATFORMS.each_key do |platform|
    if row['platforms'].include?(platform)
      platform_hash = Platform.find_by(name: platform)
      PlatformGame.create(game_id: game.id, platform_id: platform_hash.id)
    end
  end

  GENRES.each do |genre, name|
    if row['genres'].include?(genre)
      genre_hash = Genre.find_by(name: name)
      GenreGame.create(game_id: game.id, genre_id: genre_hash.id)
    end
  end

end

BODY = {
  1 => "This series is a great franchise because it gives you a sense of 'pride and accomplishment' when you play. If you're all about the gameplay, then %{game} is the game for you.\n\nI am 60 hours into the %{game}, and` I think they did a great job of letting the players do what they want in the immersive environment. Don't expect it to be like other %{genre} games because this one is special. They may have similarities at some levels, but this is a great game.\n\nIn addition, you could also have the option to enjoy the game in solo mode. If internet connection not your thing, then you could play it offline. Is it fun playing alone? Of course! Is it fun playing online with friends? Absolutely! Mounting a monster always satisfies me and the combat system is great. The atmosphere and the environment are just gorgeous. I was stunned by the beautiful ecosystem and looking at what's around me. You will enjoy every cutscene you encounter. The story is engaging, and it makes you feel that you are actually in the game. At this point, there is nothing to complain about with the game. Veterans will love this game, but for newcomers, they will somewhat complain about it. However, there is a learning curve. If you are interested in it and willing to put the time and effort then this is the game for you.",
  2 => "%{game} is amazing, easily one of the best games of this generation in my opinion. From the addictive gameplay to the great graphics, this is easily the best %{genre} game to date. The multiplayer is the best thing in this game, I did not face any connectivity issues worth mentioning. Though it can get a bit confusing sometimes, especially when trying to join a friend, but I think it will be solved in the future.",
  3 => "Can't stop playing %{game} for the past two days. I played the previous games, but the graphics evolved so much! I have to say the reason I like playing this %{genre} games is not because of the intriguing story. It's really the gameplay that stands out.\n\nYou have tons of fun trying out new things. They all form a unique system you would never see in other %{genre} games. I love games where gameplay presides over stories and graphics. This is what games are really about! they should be more than just interactive movies.",
  4 => "This is the first %{genre} game that I have played. Overall, this is a gorgeous game that is extremely fun. Systems are very polished and every encounter has weight. My main gripe with the game is that their systems are severely underexplained by the game. There are several mechanics that are not addressed in the tutorial, and while the game rushes you to keep completing main quests, it never explains the better methods to grind and collect crafting materials.\n\nFor a new player unfamiliar with these features, like myself, it was frustrating and repetitive in the beginning. Other than that, this is a very polished game, and one that if you're a fan of %{genre} games you must buy.",
  5 => "I've been playing games for a long time and I can say this is by far the best %{genre} game I've played. The visuals are absolutely amazing and there have been many QoL additions to make it easier to start for new players. I've played 30 hours and am just barely getting into the meat of the game. Each system feels easy to learn but difficult to master. This is a near perfect game!",
  6 => "I don't understand the praise %{game} gets. It's clunky, boring, repetitive, and not very challenging. I honestly didn't enjoy a single minute of the 10 or 11 hours I invested in it and consider it the worst game I've played in years. Not only are the controls an annoyingly clunky mess, I felt relief that it was over rather than any semblance of accomplishment or satisfaction. It's a very easy game that's only challenging because of the clunky game play.\n\nThis game is clearly not for me, which is very disappointing because I LOVE %{genre} games. I thought this would be a surefire purchase and instead I'm walking away from it wanting a refund and utterly baffled as to the praise and high scores that it has received.",
  7 => "I have tried and tried and tried to give %{game} a chance. To see this amazing gameplay everyone constantly cheered about. But, as soon as I started, it began to feel like the mechanics of the game were actively working against me, stopping any fun from actually happening. It's not a huge thing. At first it was just a few annoying things that were easily ignored. But once the game really starts pushing you, all the cracks feel so apparent.\n\nThe gameplay feels so incredibly slow and clunky. It may not seem like much for a %{genre} game, but given how much time you'll be putting into the game it's hard not to feel frustrated at it.",
  8 => "%{game} is passable. It’s marred by poor execution. Decent visuals only exalt it so far. Gameplay is rigid. The steep learning curve turns off newbies to %{genre} games. \n\nThe environment in %{game} is vibrant and sharp. The aesthetic is appropriate, but performance limitations hamper more impressive visuals. Overall, performance is just OK.\n\nThe story is linear and threadbare. A positive for players who want to jump into action. For the rest of us, it's unimaginative and boring. Playing with friends is a blast.\n\nThe learning curve is unnecessarily steep. New players will get lost because the opening tutorials suck and nothing is fully explained. Inventory management is a mess. However, players shouldn’t hesitate to experiment. \n\nGameplay is the weakest link. Moving is awkward. In all situations, character movement lacks fluidity. Camera angles are erratic and controlling it is a chore. The targeting feature is awful.\n\nOnce players grasp its nuances, they’ll that these flaws can be overlooked.",
  9 => "HONEST REVIEW: a mediocre %{genre} game. Honestly I wasn't sure what to expect from %{game} but it certainly wasn't what I got. Quite frankly, you never really feel powerful in this game. The combat system is also garbage. On the positive side, the world is definitely the biggest I have ever seen, and the graphics are beautiful. The colors and detail is very vibrant. I can't help but feel like they could have done it better. Honestly everything in this game feels like it is mediocre and rushed. For what they were trying to accomplish with this game, they needed at least a 4 year development cycle or more to be able to pull it off, without it feeling cheap like it does. There is some fun here, and the story is. . . decent? Because of this I still think it is mediocre at best, and only worth a buy after a couple of price drops. Just skip this title until it's in the sales bin.",
  10 => "%{game} could be a good game. Solid graphics and environments that are a step in the right direction. However, I think they took 2 steps back with the gameplay. Simply playing the game is not enough to have a good time. What a slog. It's hard to give a bad score to this game because it really is entertaining as long as you follow the beaten path and the landscape looks fantastic. The story is also ok I guess. Shame, but ultimately still could one day become a solid %{genre} game",
  # 11 => ,
  # 12 => ,
  # 13 => ,
  # 14 => ,
  # 15 => ,
  # 16 => ,
  # 17 => ,
  # 18 => ,
  # 19 => ,
  # 20 => ,
}
#
User.all.each do |user|
  user.collections.each do |collection|
    5.times do
      game_id = rand(1..208)
      game = Game.find_by(id: game_id)
      rating = rand(2..5)
      if rating > 3
        body_key = rand(1..5)
      else
        body_key = rand(6..10)
      end
      CollectionGame.create(game_id: game_id, collection_id: collection.id)
      if game.genres.first
        Review.create(
          rating: rating,
          game_id: game_id,
          user_id: user.id,
          body: (BODY[body_key] % {
            game: game.title,
            developer: game.developer.name,
            genre: game.genres.first.name}))
      else
        p game
        p game.genres
      end
    end
  end
end
