@user = User.create(username: "Nick", email: "nmhalloran@hotmail.com", password: "tigger")
@tweet = Tweet.create(content: "super duper")
@user.tweets << @tweet
