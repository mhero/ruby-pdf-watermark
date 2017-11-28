require 'combine_pdf'
require 'prawn'

watermark_png = "watermark.png"
watermark_pdf = "watermark.pdf"
to_be_watermarked_pdf = "chicken.pdf"
watermarked_pdf = "content_with_logo.pdf"

begin
	#creating pdf from png 
	pdf = Prawn::Document.new
	
	#png to pdf settings
	pdf.image(watermark_png,{:at => [50,650], :width => 500, :height => 500})
	pdf.render_file watermark_pdf
	
rescue Prawn::Errors::UnsupportedImageType
	puts "Image unsupported"
end

begin
	# load the logo as a pdf page
	company_logo = CombinePDF.load(watermark_pdf).pages[0]

	# load the content file
	pdf = CombinePDF.load to_be_watermarked_pdf

	# inject the logo to each page in the content
	pdf.pages.each {|page| page << company_logo}

	# save to a new file, with the logo.
	pdf.save watermarked_pdf
	
rescue => e
	puts "Error during merging"
end
