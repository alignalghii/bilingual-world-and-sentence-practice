{-# LANGUAGE OverloadedStrings, NamedFieldPuns #-}

module BilingualPractice.View.Practice.IndexPracticeView (indexPracticeView) where

import BilingualPractice.Model.ViewModel (PracticeView (..))
import Prelude hiding (head, div, span, min, max)
import Text.Blaze.Html5 as H hiding (map)
import Text.Blaze.Html5.Attributes as HA hiding (title, form, span, label, div)
import Network.URI.Encode (encode)
import Control.Monad (forM_)
import Data.Time (UTCTime)
import Data.Bool (bool)

indexPracticeView :: [PracticeView] -> Html
indexPracticeView practices = docTypeHtml $ do
    head $ do
        meta ! charset "UTF-8"
        link ! rel "icon" ! href "/img/favicon.ico"
        link ! rel "stylesheet" ! href "/style/form.css"
        link ! rel "stylesheet" ! href "/style/table.css"
        title "Magyar-angol szó- és mondatgyakorló — Eddigi gyakorlataid listája"
    body $ do
        h1 "Magyar-angol szó- és mondatgyakorló — Eddigi gyakorlataid listája"
        p $ do
            a ! href "/" $ "Vissza a főoldalra"
            span " •|||• "
            a ! href "/practice/new" $ "Új gyakorlat indítása"
        div $
            table $ do
                tr $ do
                    th "A gyakorlat kezdőidőpontja"
                    th "Kérdések száma"
                    th "Megmutat"
                    th "Töröl"
                    th "Megismétel"
                forM_ practices $ \ PrcVw {prcStartTimeId, prcStartTimeView, questionsCount} -> do
                    tr $ do
                        td $ toHtml prcStartTimeView
                        td $ toHtml questionsCount
                        td $ bool "" (showLink prcStartTimeId) (questionsCount > 0)
                        td $ showFormDel prcStartTimeId
                        td $ bool "" (showFormRep prcStartTimeId) (questionsCount > 0)

showLink :: UTCTime -> Html
showLink timeId = a ! href ("/practice/show/" <> (toValue $ encode $ encode $ show timeId)) $ "Mutat"

showFormDel, showFormRep :: UTCTime -> Html
showFormDel timeId = form ! method "post" ! action "/practice/delete" $ button ! type_ "submit" ! name "start" ! value (toValue $ show timeId) $ "Töröld!"
showFormRep timeId = form ! method "post" ! action "/practice/repeat" $ button ! type_ "submit" ! name "start" ! value (toValue $ show timeId) $ "Ismételd meg!"
