package rs.ac.bg.etf.pp1;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import java_cup.runtime.Symbol;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

import rs.ac.bg.etf.pp1.util.Log4JUtils;
import rs.etf.pp1.mj.runtime.Code;
import rs.etf.pp1.symboltable.Tab;

public class MJParserTest {

	static {
		DOMConfigurator.configure(Log4JUtils.instance().findLoggerConfigFile());
		Log4JUtils.instance().prepareLogFile(Logger.getRootLogger());
	}
	
	public static void main(String[] args) throws Exception {
		
		Logger log = Logger.getLogger(MJParserTest.class);
		
		Reader br = null;
		try {
			File sourceCode = new File("test/test301.mj"); // menja se prilikom testiranja programa Parser
			System.out.print("========================= SEMANTICKA OBRADA =========================\n");
			log.info("Compiling source file: " + sourceCode.getAbsolutePath());
			
			br = new BufferedReader(new FileReader(sourceCode));
			Yylex lexer = new Yylex(br);
			
			MJParser p = new MJParser(lexer);
	        Symbol s = p.parse();  //pocetak parsiranja
	        System.out.print("\n\n\n");
	        
	        
	       System.out.print("========================= SINTAKSNA ANALIZA =========================\n"); 
	       log.info("Definicije globalnih promenljivih = " + p.globalVarCnt);
	       log.info("Definicija lokalnih promenljivih (u main funkciji) = " + p.localVarInMainCnt);
	       log.info("Definicije globalnih konstanti = " + p.globalConstCnt);
	       log.info("Deklaracije globalnih nizova = " + p.globalArrayVarCnt);
	       log.info("Definicije funkcija u glavnom programu = " + p.progFuncCnt);
	       log.info("Blokovi naredbi = " + p.blockCnt);
	       log.info("Pozivi funkcija u telu metode main = " + p.funcCallInMainCnt);
	       log.info("Deklaracije formalnih argumenata funkcija = " + p.formArgsCnt);
	       log.info("Definicje unutrasnjih klasa = " + p.classCnt);
	       log.info("Definicije metoda unutrasnjih klasa = " + p.classMethodCnt);
	       log.info("Deklaracije polja unutrasnjih klasa = " + p.classFieldCnt);
	       System.out.print("\n\n\n");
	       
	       Tab.dump();
	       if (!p.errorDetected) {
	        	File objFile = new File("test/program.obj");
	        	if (objFile.exists())
	        		objFile.delete();
	        	Code.write(new FileOutputStream(objFile));
	        	
	        	log.info("Parsiranje uspesno zavrseno!");
	        }
	        else {
	        	log.error("Parsiranje NIJE uspesno zavrseno!");
	        }
	       
		} 
		finally {
			if (br != null) 
				try { 
					br.close(); 
					} 
			catch (IOException e1) { 
				log.error(e1.getMessage(), e1); 
				}
		}

	}
	
	
}
