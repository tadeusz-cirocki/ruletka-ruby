require 'colorize' # gem pozwalający na kolorowanie tekstu w terminalu

# parametry 'animacji'
speed = 40
laps = 4

# liczby na kole ruletki w kolejności. 0 zielone, potem czerwony, czarny, ...
numbers = [0,32,15,19,4,21,2,25,17,34,6,27,13,36,11,30,8,23,10,5,24,16,33,1,20,14,31,9,22,18,29,7,28,12,35,3,26]

# do wyboru: czerwone, czarne, parzyste, nieparzyste (wypłata 1:1) i numer (wypłata 1:35)

# sam początek gry

# parametr początkowej wartości portfela
balance = 1000
# ładowanie rekordu z pliku
if File.exist?('rekord.txt')
    rekord = File.read('rekord.txt').to_i
else
    rekord = balance
end

puts
puts ('uwaga, hazard uzależnia!').red
puts

puts ('/////////').yellow * 10
puts ('ROULETTE ').yellow * 10
puts ('\\\\\\\\\\\\\\\\\\').yellow * 10
puts

puts 'obecny rekord wartości portfela wynosi ' + rekord.to_s
puts

# pętla rundy
while balance > 0 do
    puts 'balans portfela: ' + balance.to_s
    puts 'wybierz cz[e]rwone, cz[a]rne, [p]arzyste, [n]ieparzyste lub [liczbę] ([x] by wyjść)'
    chosen = gets.chomp()
    if(chosen == 'x')
        break
    end
    # walidacja inputu
    if((chosen != 'e' || chosen != 'a' || chosen != 'p' || chosen != 'n') && (chosen.to_i < 0 || chosen.to_i > 36))
        puts 'źle!'
        next
    end

    puts 'ok, ile stawiasz?'
    bid = gets.to_i
    if bid == balance  # all in
        puts 'życzę powodzenia'
    end
    if bid > balance
        puts 'za mało w portfelu'
        puts
        next
    end
    puts

    # losowanie, liczenie nagrody
    win = false
    reward = 0
    random = rand(0..numbers.length)

    case chosen
    when 'e'
        puts 'wybrałeś ' + ('czerwone').red
        puts
        if(random % 2 == 1 && random != 0)
            win = true
            reward = bid
        else
            balance -= bid
        end
    when 'a'
        puts 'wybrałeś ' + 'czarne'
        puts
        if(random % 2 == 0 && random != 0)
            win = true
            reward = bid
        else
            balance -= bid
        end
    when 'p'
        puts 'wybrałeś parzyste'
        puts
        if(numbers[random] % 2 == 0 && random != 0)
            win = true
            reward = bid
        else
            balance -= bid
        end
    when 'n'
        puts 'wybrałeś nieparzyste'
        puts
        if(numbers[random] % 2 == 1 && random != 0)
            win = true
            reward = bid
        else
            balance -= bid
        end
    else
        if(chosen.to_i >= 0 && chosen.to_i <= 36)
            puts 'wybrałeś ' + chosen.yellow
            puts
            if(chosen.to_i == numbers[random])
                win = true
                reward = bid * 35
                puts 'WOW!'
                puts
            else
                balance -= bid
            end
        else
            puts 'coś poszło nie tak...'
            puts
            next
        end
    end

    # animacja
    for i in 0..numbers.length * laps - 1 do
        currentNumber = numbers[i % numbers.length]
        # zero - zielone
        if(currentNumber == 0)
            print (currentNumber.to_s + ' ').green
        else
            # nieparzysta pozycja - czerwony
            if(i % numbers.length % 2 == 1)
                print (currentNumber.to_s + ' ').red
            else
                print (currentNumber.to_s + ' ')
            end
        end
        # formula to slow it down with time
        sleep((i / numbers.length + 1) * 1.0 / speed)
        # break line at the end
        if(numbers[i % numbers.length] == numbers[numbers.length - 1])
            puts
        end
        # end on last lap on drawn field
        if(i >= (laps - 1) * numbers.length - 1 && numbers[i % numbers.length] == numbers[random])
            print '!'
            sleep(1.5)
            puts
            break
        end
    end

    puts
    if(win)
        puts ('brawo! wygrałeś ' + reward.to_s).yellow
    else
        puts 'brawo! przegrałeś ' + bid.to_s
    end

    balance += reward
    if(balance > rekord)
        rekord = balance
        File.write('rekord.txt', rekord)
        puts 'ustanowiłeś nowy rekord - ' + balance.to_s.yellow
    end

    sleep(1)
    puts
    puts

end

puts 'papa! opuszczasz z ' + balance.to_s + ' w portfelu'