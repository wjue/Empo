# encoding: utf-8


# Auhtor WANG Jue aka wjue, Copyright 2014. wjue@outlook.com
# License GPL v2
# ===============================================================================================
# The primary goal of this project is to create an application that assist Chinese classical poem
# learner to practice the specific rules of compisition, to check conformity, etc...
# Empo name is derivated from "poem" :-)
# ===============================================================================================




# Empo Models, defaut encoding is utf-8
$LOAD_PATH << '.'
require 'empo_module.rb'

include Empo

class Hzshi  # we use 'Hz' prefix for 漢字  objet 
  attr_reader "text"

  def author         # getter method
    (@author == nil) ? '不詳' : @author
  end
  
  def author=(value)
    return @author = '不詳' if (value == nil) 
    @author = (value != '') ? value : '不詳'
  end
  
  def yyunsystem     # getter method
    @yyunsystem           
  end
  
  def yyunsystem=(value) # setter method
    @yyunsystem = (['平水韻','中古韻','上古韻','新韻'].include?(value)) ? value : '平水韻'
  end
  
  def initialize(input) # input should be pre-sanitized: a string with only chinese characters and "，" "。" ponctuation symboles
    if input.include?("，") 
      @text = input
    else 
      @text = 'Error: the input text is not suitable, tips: 至少一聯兩句，上句與下句用逗號（“，”）分開，聯以句號（“。”）分開，換行可自由。'
    end
    @yyunsystem = '平水韻'
  end

  def shengdiaos(poem) # 聲調，給出全詩每字的平上去入
     s = poem         
     @rsds = []
     s.each_char {|x|
        ( ['，','。'].include?(x) ) ? @rsds << x : @rsds << Empo.shengdiao(x)      
     }
     @rsds
  end
  
  def pingzes(poem)   # 平仄，給出平仄
    #[平 ,仄]
     ar = shengdiaos(poem)         
     @rpzs = []
     ar.each {|x|      
        ( ['，','。'].include?(x) )? @rpzs << x : @rpzs << Empo.pingze(x)      
     }
     @rpzs
  end
  
  def yinyuns   # 音韻，給出字的韻母
    
  end
end


# Testing Models
# ==============

# init for Character property tables
$聲調表 = Hash.new("")    # set the default value returned by $聲調表 to an empty string 
$聲調表 = {'平'=>['平','東','童','中','同'], 
          '上'=>['上','董','動','孔','總','同'], 
          '去'=>['去','送','夢','鳳','洞'],
          '入'=>['入','屋','木','竹','目','爵']
         }

#testshi = "长安白日照春空， 绿杨结烟垂袅风 。  披香殿前花始红空，流芳发色绣户中。"
testshi = "東童孔送童東同，　送孔平東夢屋中。 　"

testshi = Empo.sanitize(testshi)

myshi = Hzshi.new(testshi) #create a Hzshi instance

puts "詩文： " << myshi.text
myshi.author= '李白'
myshi.yyunsystem='中古韻'
puts "作者： " << myshi.author
puts "音韻體系： " << myshi.yyunsystem

# testing Hzshi::shengdiaos
str = "聲調： "
myshi.shengdiaos(testshi).each {|x|
  case 
    when (x.class == String) then str << x
    when (x.class == Array)&& (x.size == 1) then str << x[0]
    else 
      str << '['
      x.each { |y| str << y }
      str << ']'
  end
  }
puts str
# ======

# testing Hzshi::pingzes
str = "平仄： "
myshi.pingzes(testshi).each { |x|
  case 
    when (x.class == String) then str << x
    when (x.class == Array)&& (x.size == 1) then str << x[0]
    else 
      str << '['
      x.each { |y| str << y }
      str << ']'
  end  
  }
puts str
# ===== 

#puts Empo.pingzes()
puts Empo.shengdiao('爵')
puts "OK"



=begin

# We define a chinese classical poem strophe "詩句" as a list of (n,n) pair, where n is the number of chinese characters.
# Generally we have n=5, or n=7. we will consider it as a 2n length unicode string

class Empostrophe # define "詩句" class, 應用: 上句，下句， 一般一聯有多句
  
  attr_accessor "phrase"
  attr_reader "type"               # type=5 五言 , type=7 七言  etc.
  
  def initialize(text)
    if text.length % 2 == 1        #in text there should be only single “，” sign as non chinese character
      @type = (text.length/2).to_s
      @phrase = text.split(/，/)
    else
      begin
        raise "Expected empo-strophe to be of even length"
      rescue => expc
        puts "#{expc.class}: #{expc.message}"
      end
    end
  end  

end

class Empo # Empo: 漢語古詩，律詩
  
  def initialize(text)
        # split the input text into strophes 聯， 每聯以句號 “。”分開
    tab = Filter(text).split(/\s*。\s*/)
    empo_s = Array.new
    tab.each {|x| empo_s << x}
    @strophes = empo_s
  end  
  
  def strophes
    @strophes
  end
end

# Control code comes here
shi = Empo.new('长安白日照春空， 绿杨结烟垂袅风 。  披香殿前花始红空，流芳发色绣户中。')


shi.strophes.each do |x| 
  strophe = Empostrophe.new(x)
  puts strophe.phrase
  puts "#{strophe.type}言"
end
=end

