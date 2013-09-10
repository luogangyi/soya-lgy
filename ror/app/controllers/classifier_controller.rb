# -*- encoding : utf-8 -*-
#encoding: utf-8
require 'uri'
require 'net/http'

class ClassifierController < ApplicationController
    skip_before_filter :authenticate_admin!

    def classify
        info_clz = get_info_class_by_name(params[:info_type])
        info_id = params[:info_id]
        info = info_clz.find(info_id)

                # save operation


        if info.operation == nil
            info.create_operation
            content = info.extract_meaningful_content

            #print content
            url = CLASSIFIER_SERVER + '?content='+ content
            #print url
            uri = URI.parse(URI.escape(url))
            resp_json = Net::HTTP.get(uri)
            classifications = ActiveSupport::JSON.decode(resp_json)


            # get and save classification results
            classifications.each do |classification|
                classification['labelIds'].each do |label_id|
                  AnalysisCategorized.where(
                    :analysable_id => info_id,
                    :analysable_type => info_clz.name,
                    :label_id => label_id,
                    :category_id => classification['categoryId']
                  ).first_or_create
                end
            end



            info.update_attributes(:sentiment => info.sentiment_in_c.label_id)


            if info_clz.name == "WeiboStatus"
                info.update_attributes(:urgency => info.calc_urgency)
                if info.calc_urgency >=3
                    if MonitoringWeiboStatus.where(:weibo_status_id=>info.id).count == 0
                        MonitoringWeiboStatus.where(
                          :weibo_status_id=>info.id,
                          :created_at => Time.now,
                          :expiring_at => Time.now + 2.day
                        ).first_or_create
                    end
                end
            end
        end
        # begin
        #   url = CLASSIFIER_SERVER + '?content=' 
        #   uri = URI.parse(URI.escape(url))
        #   resp_json = Net::HTTP.get(uri)
        #   classifications = ActiveSupport::JSON.decode(resp_json)
        #   classifications.each do |classification|
        #      p classification['categoryId']
        #   end
        # end
        render :text => "OK"
    end

    def train_histroy
        InfoCommon.subclasses.each do |info_clz|
            info_clz.joins(:operation).where(:operations => {:handled => true , :ignored => false}).each do |info|
                content = info.extract_meaningful_content
                
                #print content
                info.analysis_categorizeds.each do |alc|
                    url = CLASSIFIER_SERVER_TRAIN + '?label_id='+alc.label_id.to_s+'&content='+ content
                    print url
                    uri = URI.parse(URI.escape(url))
                    Net::HTTP.get(uri)
                end
            end
        end
        render :text => "OK"

    end



end
