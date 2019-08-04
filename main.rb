require 'discordrb'
require './private/hide.rb'
bot=Discordrb::Commands::CommandBot.new token:Hide::Token, prefix:'+'
bot.command(:kill) do |event|
    if Hide::Admin.include?(event.message.user.id)
        event.respond "shutting down"
        bot.stop()
    else
        event.respond "Im sorry, #{event.message.user.name}, but you can not do that"
    end
end
bot.command(:test) do |event|
    event.respond "Test recognised"
    puts "[info] test sent"
    puts "[user] #{event.message.user.name}"
    puts "[ id ] #{event.message.user.id}"
end
bot.command(:do) do |event|
    str=""
    arr=event.message.content.split(' ')
    (arr.length-1).times do |n|
        str+=arr[n+1]
        str+=" "
    end
    if Hide::Meme.include?(event.message.user.name.downcase)||Hide::Admin.include?(event.message.user.id)
        bot.game=str
    end
end
bot.command(:msg) do |event|
    puts "msg ran, wanted? y/n :>"
    a=gets.chomp
    if a=="y"
        msg=gets.chomp
        server=gets.to_i
        bot.send_message(server,msg)
    end
end
bot.command(:reg) do |event|
    if File.file?("./private/data/#{event.message.user.id}")
        event.respond "you already have an account"
    else
        temp=File.new("./private/data/#{event.message.user.id}",'w+')
        temp.write(100)
        temp.close()
        event.respond "registered!"
    end
end
bot.command(:bet) do |event|
    arr=event.message.content.split(' ')
    if File.file?("./private/data/#{event.message.user.id}")
        File.open("./private/data/#{event.message.user.id}",'r') do |f1|
            @bal=f1.gets.to_i
        end
        if @bal<arr[1].to_i
            event.respond "you dont have $#{arr[1]}"
        else
            roll=rand(1..50)
            event.respond roll
            case roll
            when 1..15,31..40
                event.respond "better luck next time"
                temp=File.new("./private/data/#{event.message.user.id}",'w+')
                temp.write(@bal-arr[1].to_i)
                temp.close()
            when 16..20
                event.respond "you get your money back"
            when 41..44
                event.respond "winner, you get 2x back"
                temp=File.new("./private/data/#{event.message.user.id}",'w+')
                temp.write(@bal+arr[1].to_i)
                temp.close()
            when 45..47
                event.respond "winner, you get 3x back"
                temp=File.new("./private/data/#{event.message.user.id}",'w+')
                temp.write(@bal+(arr[1].to_i*2))
                temp.close()
            when 48..49
                event.respond "winner, you get 4x back"
                temp=File.new("./private/data/#{event.message.user.id}",'w+')
                temp.write(@bal+(arr[1].to_i*3))
                temp.close()
            when 50
                event.respond "JACKPOT, you get 5x back"
                temp=File.new("./private/data/#{event.message.user.id}",'w+')
                temp.write(@bal+(arr[1].to_i*4))
                temp.close()
            end
        end
    else
        event.respond "you have no account, please use +reg to register"
    end
end
bot.command(:bal) do |event|
    if File.file?("./private/data/#{event.message.user.id}")
        File.open("./private/data/#{event.message.user.id}",'r') do |f1|
            event.respond f1.gets
        end
    else
        event.respond "you have no account, please use +reg to register"
    end
end
bot.run