# encoding: utf-8

# Auhtor WANG Jue aka wjue, Copyright 2014. wjue@outlook.com
# License GPL v2
# ===============================================================================================

# Common utilities come here ...

module Empo
  def self.sanitize(text_raw)
    text_raw.gsub!(/[\s \n　]/,"")
  end
=begin
  def self.shengdiao(hzchar)
    # for test
    @result = ""
    sn = ( $聲調表['平'].include?(hzchar) ) ? @result <<'平' : ''
    #    @result << sn
    sn = ( $聲調表['上'].include?(hzchar) ) ? @result <<'上' : ''
    @result << '/'+sn
    sn = ( $聲調表['去'].include?(hzchar) ) ? '去' : ''
    @result << sn
    sn = ( $聲調表['入'].include?(hzchar) ) ? '入' : ''
    @result << sn

    puts 'shengdiao shi :' + @result
    @result

  end
=end

  def self.shengdiao(hzchar)
    @rsd = []     # returning an array 某些字的聲調可以有多種，故輸出設為 array
    ( $聲調表['平'].include?(hzchar) ) ? @rsd <<'平' : ''
    ( $聲調表['上'].include?(hzchar) ) ? @rsd <<'上' : ''
    ( $聲調表['去'].include?(hzchar) ) ? @rsd <<'去' : ''
    ( $聲調表['入'].include?(hzchar) ) ? @rsd <<'入' : ''
    if @rsd == [] 
      begin
        raise hzchar.to_str + ": 抱歉，數據庫資料不全，暫時無法確定這個字的聲調。"
      rescue => expc
        puts "#{expc.class}: #{expc.message}"
      end
    end
    @rsd
  end

  def self.pingze(hzinput)
    @rpz = []     # returning an array 某些字可平可仄，故輸出設為 array
            
    # if hzinput is an array the return value is also an array
    xar = []
    hzinput.class == Array ? hzarray = hzinput : hzarray = [hzinput]
      hzarray.each { |x| 
        xar = self.shengdiao(x)
        return [] if (xar == [])
        if xar[0] == '平'
          then
            @rpz << '平' 
            if xar.length >= 2
              @rpz << '仄'
            end
          else
            @rpz << '仄'
        end
      }
      
    # simplify return value for that [仄仄仄]=[仄仄]=[仄]  [平仄仄]=[平仄]
    case  # return @rpz
      when (@rpz.size == 1) then @rpz
      when (@rpz.size == 2) then (@rpz[0] == @rpz[1]) ? @rpz[1,1] : @rpz
      when (@rpz.size > 2) then (@rpz[0] == @rpz[1]) ? @rpz[1,1] : @rpz[0,2]
    end
   
  end

  def self.yinyun(hzchar)
  end

end