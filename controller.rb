require 'sinatra'
require 'sinatra/reloader'
require './user'

enable :sessions

get '/home' do
    erb(:home)
end

get '/logon' do
    erb(:logon)
end

post '/logon' do

    input_username = params[:uname]
    input_password = params[:psw]

    user = User.get(input_username)
    if user == nil
        @username_not_exist = true
        erb(:logon)
   else
        if input_password == user.password
            redirect '/game/' + input_username
        else
            @password_not_correct = true
            erb(:logon)
        end 
   end
end

get '/signup' do
    @user_name_existed = false
    erb(:signup)
end

post '/signup' do
    @username = params[:uname]
    @password = params[:psw]
    if User.get(@username) != nil
        @user_name_existed = true
        erb(:signup)
    else
        User.create(username:@username, password:@password, totalwin:0, totalloss:0, totalprofit:0)
        redirect '/game/' + @username
    end
end

get '/game/:username' do
    @user = User.get(params[:username])
    @username = params[:username]
    erb(:game)
end

post '/game/:username' do
    @user = User.get(params[:username])

    if !session[:totalwin]
        session[:totalwin] = 0
    end
    if !session[:totalloss]
        session[:totalloss] = 0
    end
    if !session[:totalprofit]
        session[:totalprofit] = 0
    end

    @dice = rand(6)+1

    bet_money = params[:bmoney].to_i
    bet_number = params[:bnumber].to_i

    if @dice == bet_number
        session[:totalwin] += bet_money
        session[:totalprofit] += bet_money
        @user.totalwin += bet_money
        @user.totalprofit += bet_money
    else
        session[:totalloss] += bet_money
        session[:totalprofit] -= bet_money
        @user.totalloss += bet_money
        @user.totalprofit -= bet_money
    end
    @user.save
    erb(:game)
end

get '/logout' do
    session.clear
    redirect '/home'
end