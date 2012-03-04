#import('dart:html');
#import('../Reactive-Dart/lib/reactive_lib.dart');

class PhotoScroller {

  String dummyImage = "dummyImage.png";
  List dummyList;
  Element container; 
  Element scrollToTop;
  int scrollLoadOffset = 400;
  IObservable scrollObservable;
  IObservable fetchImagesObservable;
  PhotoScroller() {
  }

  loadImage(imageLoc) {
    container.nodes.add(new Element.html("<a href='${imageLoc}'><img src='${imageLoc}'/></a>"));
  }
  
  void run() {
    createContainer();
    
    // Create dummy list
    dummyList = [dummyImage, dummyImage, dummyImage,
                 dummyImage, dummyImage, dummyImage,
                 dummyImage, dummyImage, dummyImage,
                 dummyImage, dummyImage, dummyImage];
    
    // Fetch images
    fetchImagesObservable = Observable.fromList(dummyList);
    fetchImagesObservable.subscribe(loadImage);
    
    // Attach scrolling event to Observable and if scroll bars reach bottem of page, load more
    scrollObservable = Observable.fromEvent(window.on.scroll);
    scrollObservable.subscribe((e) {
      container.rect.then((ElementRect rect) {
        if (window.outerHeight + window.scrollY + scrollLoadOffset > rect.scroll.height) {
          fetchImagesObservable = Observable.fromList(dummyList);
          fetchImagesObservable.subscribe(loadImage);
        }
        
        if (window.outerHeight < window.scrollY) {     
          scrollToTop.style.top = window.outerHeight/2;       
        } else {
          scrollToTop.style.top = -window.outerHeight/2;
        }
      });
    });
  }
  
  createContainer() {
    container = new Element.html("<div id='container'></div>");
    document.body.nodes.add(container);
    scrollToTop = new Element.html("""<a id="scrollToTop" href="#" class="scrollToTop"><strong>Scroll to Top</strong><span></span></a>""");
    document.body.nodes.add(scrollToTop);
    scrollToTop.style.top = -window.outerHeight/2;
    scrollToTop.classes.add("transitionScrollToTop");
  }
}

void main() {
  new PhotoScroller().run();
}
