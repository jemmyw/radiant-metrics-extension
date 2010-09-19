class AbTestPage < Page
  description %{
    An A/B page shows either the first or second child pages to
    visitors on a random basis.
  }

  belongs_to :ab_test

  def cache?
    false
  end

  def process(request, response)
    @request, @response = request, response
    @page = choose
    @page.process(request, response)
  end

  def choose
    Vanity.context = self

    if experiment && experiment.choose
      page_b
    else
      page_a
    end
  end

  def experiment
    AbTest.find(ab_test_id).experiment
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def page_a
    children.find(:first, :conditions => {:status_id => Status[:published].id})
  end

  def page_b
    children.find(:first, :offset => 1, :conditions => {:status_id => Status[:published].id})
  end
end