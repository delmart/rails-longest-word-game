

class LongestWordController < ApplicationController
  def game
    session[:grid] = generate_grid
  end

  def score
    end_time = Time.now
    @answer = params[:answer]
    start_time = params[:start_time].to_datetime
    @total_time = (end_time - start_time).round(2)
    @translation = get_translation(@answer)
    @score = compute_score(@answer, @total_time)
  end


  private

  def compute_score(answer, time_taken)
    score = (time_taken > 60.0) ? 0 : answer.size * (1.0 - time_taken / 60.0)
    score.round(2)
  end

  def generate_grid
    grid = []
    10.times{ grid << ('A'..'Z').to_a.sample }
    grid
  end

  def get_translation(attempt)
    api = 'https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key='
    key = 'cdf01b7c-89ee-48fe-a21f-14133d773540'
    url = "#{api}#{key}&input=#{attempt}"
    translation = JSON.parse(open(url).read) #url_to_hash(url)
    if translation["outputs"][0]["output"] == attempt
     return nil
    else
     return translation["outputs"][0]["output"]
    end
  end
end
