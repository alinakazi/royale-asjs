////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.jewel.beads.views
{
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IAlertModel;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.events.CloseEvent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.html.Group;
    import org.apache.royale.html.beads.GroupView;


    import org.apache.royale.jewel.Alert;
    import org.apache.royale.jewel.Label;
    import org.apache.royale.jewel.TextButton;
    import org.apache.royale.jewel.TitleBar;
    import org.apache.royale.jewel.ControlBar;
	
    COMPILE::SWF
	{
        import org.apache.royale.html.beads.IBackgroundBead;
        import org.apache.royale.html.beads.IBorderBead;
        import org.apache.royale.core.IMeasurementBead;
        import org.apache.royale.core.ValuesManager;
        import org.apache.royale.geom.Rectangle;
        import org.apache.royale.utils.loadBeadFromValuesManager;
	}
	
	/**
	 *  The AlertView class creates the visual elements of the org.apache.royale.jewel.Alert
	 *  component. The job of the view bead is to put together the parts of the Alert, such as the 
	 *  title bar, message, and various buttons, within the space of the Alert component strand.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AlertView extends GroupView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AlertView()
		{
		}
		
		protected var titleBar:TitleBar;
		protected var controlBar:UIBase;
		protected var label:Label;
		protected var labelContent:Group;

        protected var okButton:TextButton;
        protected var cancelButton:TextButton;
        protected var yesButton:TextButton;
        protected var noButton:TextButton;

        protected var alertModel:IAlertModel;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			COMPILE::SWF
            {
                var backgroundColor:Object = ValuesManager.valuesImpl.getValue(value, "background-color");
                var backgroundImage:Object = ValuesManager.valuesImpl.getValue(value, "background-image");
                if (backgroundColor != null || backgroundImage != null)
                {
                    loadBeadFromValuesManager(IBackgroundBead, "iBackgroundBead", value);
                }

                var borderStyle:String;
                var borderStyles:Object = ValuesManager.valuesImpl.getValue(value, "border");
                if (borderStyles is Array)
                {
                    borderStyle = borderStyles[1];
                }
                if (borderStyle == null)
                {
                    borderStyle = ValuesManager.valuesImpl.getValue(value, "border-style") as String;
                }
                if (borderStyle != null && borderStyle != "none")
                {
                    loadBeadFromValuesManager(IBorderBead, "iBorderBead", value);
                }
            }

			alertModel = (_strand as UIBase).model as IAlertModel;

			createButtons();

			if (alertModel.title)
            {
                titleBar = new TitleBar();
                //titleBar.height = 25;
                titleBar.title = alertModel.title;
                IParent(_strand).addElement(titleBar);
            }

			label = new Label();
			label.text = alertModel.message;
			
			labelContent = new Group();
			labelContent.percentWidth = 100;
			labelContent.percentHeight = 100;

			labelContent.addElement(label);
			
            IParent(_strand).addElement(labelContent);

			/*COMPILE::JS
			{
                label.element.style["white-space"] = "unset";
				labelContent.element.style["minHeight"] = "30px";
				controlBar.element.style["flex-direction"] = "row";
				controlBar.element.style["justify-content"] = "flex-end";
				controlBar.element.style["border"] = "none";
				controlBar.element.style["background-color"] = "#FFFFFF";
			}*/
            IParent(_strand).addElement(controlBar);

			COMPILE::SWF
            {
                refreshSize();
            }
		}

		private function createButtons():void
		{
			COMPILE::SWF
			{
				controlBar = new Group();
            }

			COMPILE::JS
			{
				controlBar = new ControlBar();
			}

            var flags:uint = alertModel.flags;
            if( flags & Alert.OK )
            {
                okButton = new TextButton();
                okButton.text = alertModel.okLabel;
                okButton.addEventListener("click",handleOK);

                controlBar.addElement(okButton);

                /*COMPILE::JS
                {
                    okButton.element.style["margin-left"] = "2px";
                    okButton.element.style["margin-right"] = "2px";
                }*/
            }
            if( flags & Alert.CANCEL )
            {
                cancelButton = new TextButton();
                cancelButton.text = alertModel.cancelLabel;
                cancelButton.addEventListener("click",handleCancel);

                controlBar.addElement(cancelButton);

                /*COMPILE::JS
                {
                    cancelButton.element.style["margin-left"] = "2px";
                    cancelButton.element.style["margin-right"] = "2px";
                }*/
            }
            if( flags & Alert.YES )
            {
                yesButton = new TextButton();
                yesButton.text = alertModel.yesLabel;
                yesButton.addEventListener("click",handleYes);

                controlBar.addElement(yesButton);

                /*COMPILE::JS
                {
                    yesButton.element.style["margin-left"] = "2px";
                    yesButton.element.style["margin-right"] = "2px";
                }*/
            }
            if( flags & Alert.NO )
            {
                noButton = new TextButton();
                noButton.text = alertModel.noLabel;
                noButton.addEventListener("click",handleNo);

                controlBar.addElement(noButton);

                /*COMPILE::JS
                {
                    noButton.element.style["margin-left"] = "2px";
                    noButton.element.style["margin-right"] = "2px";
                }*/
            }
		}

		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		COMPILE::SWF
		private function refreshSize():void
		{
			var labelMeasure:IMeasurementBead = label.measurementBead;
			var titleMeasure:IMeasurementBead = titleBar.measurementBead;
			var titleBarWidth:Number = titleBar ? titleBar.measurementBead.measuredWidth : 0;

			var maxWidth:Number = Math.max(titleMeasure.measuredWidth, titleBarWidth, labelMeasure.measuredWidth);

			var metrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(_strand as IUIBase);

            var titleBarHeight:Number = 0;
			if (titleBar)
            {
                titleBarHeight = titleBar.height;
                titleBar.x = 0;
                titleBar.y = 0;
                titleBar.width = maxWidth;
                titleBar.dispatchEvent(new Event("layoutNeeded"));
            }

			// content placement here
			label.x = metrics.left;
			label.y = titleBarHeight + metrics.top;
			label.width = maxWidth - metrics.left - metrics.right;
			
			controlBar.x = 0;
			controlBar.y = titleBarHeight + label.y + label.height + metrics.bottom;
			controlBar.width = maxWidth;
			controlBar.dispatchEvent(new Event("layoutNeeded"));
			
			UIBase(_strand).width = maxWidth;
			UIBase(_strand).height = titleBarHeight + label.height + controlBar.height + metrics.top + metrics.bottom;
		}
		
		/**
		 * @private
		 */
		private function handleOK(event:MouseEvent):void
		{
			// create some custom event where the detail value
			// is the OK button flag. Do same for other event handlers
			dispatchCloseEvent(Alert.OK);
		}
		
		/**
		 * @private
		 */
		private function handleCancel(event:MouseEvent):void
		{
			dispatchCloseEvent(Alert.CANCEL);
		}
		
		/**
		 * @private
		 */
		private function handleYes(event:MouseEvent):void
		{
			dispatchCloseEvent(Alert.YES);
		}
		
		/**
		 * @private
		 */
		private function handleNo(event:MouseEvent):void
		{
			dispatchCloseEvent(Alert.NO);
		}
		
		/**
		 * @private
		 */
		public function dispatchCloseEvent(buttonFlag:uint):void
		{
			var closeEvent:CloseEvent = new CloseEvent("close", false, false, buttonFlag);
			IEventDispatcher(_strand).dispatchEvent(closeEvent);
		}
	}
}
