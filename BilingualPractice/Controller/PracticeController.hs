{-# LANGUAGE OverloadedStrings, NamedFieldPuns #-}

module BilingualPractice.Controller.PracticeController where

import BilingualPractice.Controller.Base (blaze)
import BilingualPractice.Model.RelationalBusinessLogic (numeralsRelation)
import BilingualPractice.Model.TableManipulationForBusinessLogic (preparePracticeControllingTables)
import BilingualPractice.View.Practice.ExamenView   (examenView)
import System.RandomX (randQuery)
import Web.Scotty (ActionM, param, redirect)
import Control.Monad.Trans (liftIO)


proposeExamenAction :: ActionM ()
proposeExamenAction = blaze examenView

performExamenAction :: ActionM ()
performExamenAction = do
    numberOfQuestions <- read <$> param "number_of_questions" -- @TODO: form validation
    liftIO $ randQuery numberOfQuestions numeralsRelation >>= preparePracticeControllingTables
    redirect "/question"
