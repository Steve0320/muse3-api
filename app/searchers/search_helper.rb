# A collection of helpers for searching
module SearchHelper

  # Translate a start and max into a range of pages
  def page_range(start, max, results_per_page)
    start_page = (start / results_per_page) + 1
    end_page = ((start + max - 1) / results_per_page) + 1
    return start_page..end_page
  end

  # Slice down an a results array into the appropriate size,
  # assuming a minimum number of pages
  def results_range(start, max, results_per_page)
    start_slice = start % results_per_page
    end_slice = start_slice + max - 1
    return start_slice..end_slice
  end

end